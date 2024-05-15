const time = Variable("", {
  poll: [60000, 'date "+%H\n%M"'],
});

export default Widget.Label({
  className: "clock",
  hpack: "center",
  vpack: "start",
  label: time.bind(),
});
