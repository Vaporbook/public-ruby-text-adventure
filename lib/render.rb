VOID_NODE_BODY_MSG = 'There is nothing here but a Nullifying Vortex of Void!'

def render_node(node)
    n = hashify(node)
    render_box(n)
    next_node = render_prompt(n)
    render_node(next_node)
end

def render_box(node)
    cursor = TTY::Cursor
    print cursor.move_to(0,0)
    print cursor.clear_screen
    box = TTY::Box.frame(
            enable_color: true, # force to always color output
            style: {
                border: {
                    fg: :bright_yellow,
                    bg: :blue
                }
            },
            width: TTY::Screen.width,
            title: { top_left: node[:title] }) do
        node[:body]
    end
    print box
end

def render_prompt(node)
    prompt = TTY::Prompt.new
    selection = prompt.select("Option") do |menu|
        node[:choices].each do |selection|
            label = selection.xpath('.').inner_text
            id = selection.xpath('@href')
            menu.choice "#{label}", id
        end
    end
    lookup_node(selection.first.value.tr('#',''))
end

def load_game(id)
    render_game
end

def render_game
    player = Player.new
    root = CONTENT_DOM.xpath('//body//article[1]')

    cursor = TTY::Cursor
    print cursor.move_to(0,0)
    
    binding.pry

    selection = render_node(root)
    puts selection
end

def render_loadmenu
    cursor = TTY::Cursor
    prompt = TTY::Prompt.new
    directories = Dir.children('data/')
    games = directories.map do |dir|
        dom = load_dom(dir)        
        {
            id: dir,
            title: dom.xpath('//head//title').inner_text,
            dom: dom
        }
    end

    print cursor.clear_screen
    prompt.select("Choose the adventure to run") do |menu|
        games.each do |game|
            menu.choice game[:title], game[:id]
        end
    end
end