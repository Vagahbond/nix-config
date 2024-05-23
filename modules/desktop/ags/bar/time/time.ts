const time = Variable("", {
  poll: [60000, 'date "+%H\n%M"'],
});

export default Widget.Box({
  vertical: true,
  className: "clock",
  vpack: "start",
  widthRequest: 40,
  children: [
    Widget.Label({
      justification: "center",
      label: time.bind(),
    }),
  ],
});
