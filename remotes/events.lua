events = {}
events['on_tree_planted'] = script.generate_event_name()

remotes.getEvents = function()
  return events
end
