class_name Trie extends Node

class TNode:
	var info
	var sons = {}
	var end_of_word
	
	func add_info(info):
		self.info = info
	
	func set_end_of_word():
		end_of_word = true
	
	func has_child(i):
		return sons.has(i)
	
	func get_child(i):
		var child = null
		if(has_child(i)):
			child = sons[i]
		return child

var root : TNode

func _init():
	root = TNode.new()

func add_word(string):
	var iter = root
	for i in string:
		if(!iter.has_child(i)):
			iter.sons[i] = TNode.new()
			iter.sons[i].add_info(i)
		iter = iter.get_child(i)
	iter.set_end_of_word()

func find_word(string):
	var node_end = find_prefix(string)
	return node_end.end_of_word if(node_end != null) else false

func find_prefix(string):
	var i = 0
	var iter = root
	while(i < string.length() and iter != null):
		if(iter.has_child(string[i])):
			iter = iter.get_child(string[i])
		else:
			iter = null
		i+=1
	return iter

func find_all_words(prefix):
	var node_end = find_prefix(prefix)
	var word_list = find_all_words_recursive(prefix,node_end)
	if(node_end != null and node_end.end_of_word):
		word_list.append(prefix)
	return word_list

func find_all_words_recursive(prefix,node_end):
	var word_list = []
	if(node_end != null):
		for i in node_end.sons.values():
			if(i.end_of_word):
				word_list.append(prefix+i.info)
			word_list.append_array(find_all_words_recursive(prefix+i.info,i))
	return word_list

func delete_word(string):
	delete_word_recursive(null,root,string,0)

func delete_word_recursive(parent,root,string,level):
	if(!is_empty()):
		if(level == string.length()):
			if(root.end_of_word):
				root.end_of_word = false
			if(root.sons.size() == 0 and parent != null):
				parent.sons.erase(root.info)
		else:
			var key = string[level]
			delete_word_recursive(root,root.get_child(key),string,level+1)
			if(root.sons.size() == 0 and !root.end_of_word and parent != null):
				parent.sons.erase(root.info)

func is_empty():
	return root.sons.size() == 0
