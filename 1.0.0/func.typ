#let justify(str) = {
  let ret = ()
  let str = str.at("children").filter(x => x != [ ]).map(c => c.text).join()
  for char in str {
    ret.push(char)
    ret.push([#h(1fr)])
  }
  ret.remove(-1)
  return ret.join()
}