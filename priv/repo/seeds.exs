alias Stat.Repo
alias Stat.Locations.City
alias Stat.Consumables.StickerType

Repo.delete_all(City)

Repo.insert! %City{
  name: "Waterloo",
  longitude: -80.543441,
  latitude: 43.464257,
  country: "CA"
}

Repo.delete_all(StickerType)

File.ls!("priv/static/stickers/")
|> Enum.flat_map(fn dir ->
  Enum.map(File.ls!("priv/static/stickers/#{dir}"),
  fn f -> Path.join(dir, f) end) end)
|> Enum.map fn file ->
  Repo.insert! %StickerType{
    name: Path.join(Path.dirname(file), Path.basename(file, ".png")),
    url: "stickers/#{file}"
  }
end
