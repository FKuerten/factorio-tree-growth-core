remotes = {}
require "remotes/treeData"
require "remotes/groups"
require "remotes/events"

script.on_init(function()
  if not global.events then 
    global.events = {}
  end
  if not global.events['on_tree_planted'] then
    global.events['on_tree_planted'] = script.generate_event_name()
  end
end)

remote.add_interface("tree-growth-core", remotes)