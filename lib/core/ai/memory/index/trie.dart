class TrieNode {
  Map<String, TrieNode> children = {};
  Set<String> ids = {};
}

class Trie {
  final TrieNode root = TrieNode();
  void insert(String word, String id) {
    var node = root;
    for (var ch in word.split('')) {
      node = node.children.putIfAbsent(ch, ()=>TrieNode());
    }
    node.ids.add(id);
  }
  Set<String> searchPrefix(String prefix) {
    var node = root;
    for (var ch in prefix.split('')) {
      if (!node.children.containsKey(ch)) return {};
      node = node.children[ch]!;
    }
    return _collect(node);
  }
  Set<String> _collect(TrieNode node) {
    var result = Set<String>.from(node.ids);
    for (var child in node.children.values) {
      result.addAll(_collect(child));
    }
    return result;
  }
  void remove(String word, String id) {
    _remove(root, word, 0, id);
  }
  bool _remove(TrieNode node, String word, int index, String id) {
    if (index == word.length) {
      node.ids.remove(id);
      return node.ids.isEmpty && node.children.isEmpty;
    }
    var ch = word[index];
    var child = node.children[ch];
    if (child == null) return false;
    var shouldDelete = _remove(child, word, index+1, id);
    if (shouldDelete) {
      node.children.remove(ch);
      return node.ids.isEmpty && node.children.isEmpty;
    }
    return false;
  }
}
