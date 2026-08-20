; extends

((jsx_opening_element
  name: (identifier) @tag.framework)
  (#lua-match? @tag.framework "-"))

((jsx_closing_element
  name: (identifier) @tag.framework)
  (#lua-match? @tag.framework "-"))

((jsx_self_closing_element
  name: (identifier) @tag.framework)
  (#lua-match? @tag.framework "-"))

(jsx_opening_element
  name: (member_expression) @tag.framework)

(jsx_closing_element
  name: (member_expression) @tag.framework)

(jsx_self_closing_element
  name: (member_expression) @tag.framework)
