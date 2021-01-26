def load_dom(game_id)
    Nokogiri::HTML.parse(File.read("data/#{game_id}/world.html"))
end

CONTENT_INDEX = {}
CONTENT_DOM = load_dom('adventure')
CONTENT_DOM.xpath('//body//article[@id]').each do |node|
    raise 'Corrupted content detected. Failing.' unless node
    id_attr = node.attribute('id')
    raise 'Corrupted content detected. Failing.' unless id_attr
    id = id_attr.value
    raise 'Duplicate id detected in world content.' if CONTENT_INDEX.key?(node.attribute('id').value)
    choices = node.xpath('ul[@class="choices"]')
    raise 'No choice block defined on content node (ul[@class="choices"]), failing.' unless choices.length > 0
    CONTENT_INDEX[node.attribute('id').value] = node
end

def lookup_node(selection)
    CONTENT_INDEX[selection]
end

def hashify(node)
    body = node.xpath('article[@class="body"]').inner_text.lstrip
    body = VOID_NODE_BODY_MSG unless body.length > 0
    {
        id: node.attribute('id').value,
        title: node.xpath('h1').inner_text,
        body: body,
        choices: node.xpath('ul[@class="choices"]//a')
    }
end