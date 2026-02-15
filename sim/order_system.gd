extends RefCounted
class_name OrderSystem

func apply_order(state: SimState, order_id: String) -> Array[String]:
	var events: Array[String] = []
	if order_id == "raise_shields":
		events.append("Tactical: Aye, Captain.")
		if state.systems.get("shields", false):
			events.append("Shields are already raised.")
		else:
			state.systems["shields"] = true
			events.append("Shields raised.")
	else:
		events.append("Unknown order: %s" % order_id)
	return events
