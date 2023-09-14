let
  kubeRoot = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH0gu6NykWTHA/7S6UCLrFbea83QPG7qVkNv0tRieGQO";
  # blade = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC5ioPLcUGrV4EaH6ZJP7aC8EUcizdYzD8CJtlp8vYACY5jHAKelyksSpxzeHQs8xyqDUw7clj9mvvHXUCVojw05bCgLg4g8K6Safq6GzO2qwT+GlQjJWmaYkYcqPbJsHJsPeeaTtFzvgEV9Zgd3apxS32A2r0UFl8Nn5ttas8U2PoiE0rhtaOT1CZAs1VdJeH5umBTVH5bUt79uP+nAPPZmnTpas+hpQehGv+QmEgfyXixI4qRWUvPH5gCspBOUxyuY0nCHhoOVCjIm7SkcTopP+R6Va3e5vlymZ5sYkwAcCyk0xUE83iRHJQ6LZJrW6q+AWR7MXqg8MU4PrUEJWt5";
  framework = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILFusXTBhXLpViUVKjfHRJnjVb6WZFrxYq2/0Kh7MKwN pro@yoni-firroloni.com";
in {
  # TODO: Redo the whole wifi access points secrets
  # add every ssh key that's not my main ssh key for next time I break my conf (fuck me running)

  # Wifi passwords
  "wifi.age".publicKeys = [framework];
  "kubeconfig.age".publicKeys = [framework];
  "password.age".publicKeys = [framework];
}
