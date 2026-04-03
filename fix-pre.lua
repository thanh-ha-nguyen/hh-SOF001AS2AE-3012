function RawBlock (el)
  if el.format == "html" and el.text:match("<pre") then
    -- 1. Strip the <pre> tags
    local content = el.text:gsub("</?pre[^>]*>", "")
    
    -- 2. Preserve Indentation: Replace leading spaces with non-breaking spaces
    -- This looks for spaces at the start of a line and converts them
    content = content:gsub("\n +", function(s) 
      return s:gsub(" ", "&nbsp;")
    end)
    
    -- 3. Preserve Newlines: Convert \n to <br/>
    content = content:gsub("\n", "<br/>")
    
    -- 4. Parse the content (handles <ins> and &nbsp; automatically)
    local doc = pandoc.read(content, "html")
    
    -- 5. Wrap in "Source Code" style for Word
    return pandoc.Div(doc.blocks, {["custom-style"] = "Source Code"})
  end
end