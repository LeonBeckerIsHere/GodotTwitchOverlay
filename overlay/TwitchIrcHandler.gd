extends Gift

@export var guppy_scene:PackedScene
@onready var root = get_node("/root/Overlay/Guppies")

func _ready() -> void:
	
	cmd_no_permission.connect(no_permission)
	chat_message.connect(on_chat)
	event.connect(on_event)

	# I use a file in the working directory to store auth data
	# so that I don't accidentally push it to the repository.
	# Replace this or create a auth file with 3 lines in your
	# project directory:
	# <client_id>
	# <client_secret>
	# <initial channel>
	var authfile := FileAccess.open("./overlay/auth.txt", FileAccess.READ)
	client_id = authfile.get_line()
	client_secret = authfile.get_line()
	var initial_channel = authfile.get_line()



	# When calling this method, a browser will open.
	# Log in to the account that should be used.
	await(authenticate(client_id, client_secret))
	var success = await(connect_to_irc())
	if (success):
		request_caps()
		join_channel(initial_channel)
		await(channel_data_received)
	#await(connect_to_eventsub()) # Only required if you want to receive EventSub events.
	# Refer to https://dev.twitch.tv/docs/eventsub/eventsub-subscription-types/ for details on
	# what events exist, which API versions are available and which conditions are required.
	# Make sure your token has all required scopes for the event.
	#subscribe_event("channel.follow", 2, {"broadcaster_user_id": user_id, "moderator_user_id": user_id})

	# These two commands can be executed by everyone
	add_command("helloworld", hello_world)
	
	spawn_chatters()

func on_event(type : String, data : Dictionary) -> void:
	match(type):
		"channel.follow":
			print("%s followed your channel!" % data["user_name"])
			
func no_permission(cmd_info : CommandInfo) -> void:
	chat("NO PERMISSION!")

func hello_world(cmd_info : CommandInfo) -> void:
	chat("HELLO WORLD!")

func on_chat(senderdata : SenderData, msg : String) -> void:
	upsert_chatter(senderdata.tags["display-name"])
	
	var time = Time.get_time_dict_from_system()
	var badges : String = ""
	for badge in senderdata.tags["badges"].split(",", false):
		var result = await(get_badge(badge, senderdata.tags["room-id"]))
		badges += "[img=center]" + result.resource_path + "[/img] "
	var locations : Array = []
	if (senderdata.tags.has("emotes")):
		for emote in senderdata.tags["emotes"].split("/", false):
			var data : Array = emote.split(":")
			for d in data[1].split(","):
				var start_end = d.split("-")
				locations.append(EmoteLocation.new(data[0], int(start_end[0]), int(start_end[1])))
	locations.sort_custom(Callable(EmoteLocation, "smaller"))
	var offset = 0
	for loc in locations:
		var result = await(get_emote(loc.id))
		var emote_string = "[img=center]" + result.resource_path +"[/img]"
		msg = msg.substr(0, loc.start + offset) + emote_string + msg.substr(loc.end + offset + 1)
		offset += emote_string.length() + loc.start - loc.end - 1
		
	print_msg("%02d:%02d" % [time["hour"], time["minute"]], senderdata, msg, badges)
		
func print_msg(stamp : String, data : SenderData, msg : String, badges : String) -> void:
	print(stamp + " " + badges + "[b][color="+ data.tags["color"] + "]" + data.tags["display-name"] +"[/color][/b]: " + msg)
	
func spawn_chatters():
	var chatters:Array = await get_chatters()
	print(chatters)
	for chatter in chatters:
		upsert_chatter(chatter["user_name"])

func upsert_chatter(user_name:String):
	var userNode = get_node_or_null("/root/Overlay/Guppies/" + user_name)
	if(userNode == null):
		var new_guppy = guppy_scene.instantiate()
		new_guppy.name = user_name
		new_guppy.init(Vector2(randi_range(64,1880),980),user_name)
		root.add_child(new_guppy)
	else:
		userNode.keep_alive()
		
func twitch_on_timer_timeout():
	spawn_chatters()
	
class EmoteLocation extends RefCounted:
	var id : String
	var start : int
	var end : int

	func _init(emote_id, start_idx, end_idx):
		self.id = emote_id
		self.start = start_idx
		self.end = end_idx

	static func smaller(a : EmoteLocation, b : EmoteLocation):
		return a.start < b.start



