atom_feed do |feed|
  feed.title("Mockr")
  feed.updated(@mocks.first.created_at)

  @mocks.each do |mock|
    feed.entry(mock) do |entry|
      entry.title(mock.title)
      entry.content(render(:partial => "entry_content.html.erb",
        :locals => {:mock => mock}), :type => "html")
      entry.author do |author|
        author.name "Chris Chan"
      end
    end
  end
end
