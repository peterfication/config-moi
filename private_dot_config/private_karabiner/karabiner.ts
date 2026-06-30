import { map, rule, writeToProfile } from "karabiner-ts";

const karabinerJsonPath = new URL("./karabiner_new.json", import.meta.url).pathname;

writeToProfile(
  {
    name: "Default profile",
    karabinerJsonPath,
  },
  [
    rule("Demo").manipulators([
      map(1).to(2),
    ]),
  ],
);
