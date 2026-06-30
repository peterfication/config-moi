type KeyTo = {
  key_code: string;
  modifiers?: string[];
};

type ToEvent = KeyTo | { set_variable: { name: string; value: number } } | {
  mouse_key: Record<string, number>;
} | { pointing_button: string };

type Manipulator = {
  description?: string;
  conditions?: Array<Record<string, string | number>>;
  from: Record<string, unknown>;
  parameters?: Record<string, number>;
  to?: ToEvent[];
  to_after_key_up?: ToEvent[];
  to_if_alone?: ToEvent[];
  to_if_held_down?: ToEvent[];
  to_if_other_key_pressed?: Array<Record<string, unknown>>;
  type: "basic";
};

type Rule = {
  description: string;
  enabled?: boolean;
  manipulators: Manipulator[];
};

const karabinerJsonPath = new URL("./karabiner_new.json", import.meta.url).pathname;

const optionalAny = { optional: ["any"] };
const fnAny = { mandatory: ["fn"], optional: ["any"] };
const hyper = { mandatory: ["command", "shift", "option", "control"] };

function fromKey(keyCode: string, modifiers: Record<string, unknown> = optionalAny) {
  return { key_code: keyCode, modifiers };
}

function toKey(keyCode: string, modifiers?: string[]): KeyTo {
  return modifiers ? { key_code: keyCode, modifiers } : { key_code: keyCode };
}

function variableCondition(name: string, type: "variable_if" | "variable_unless") {
  return [{ name, type, value: 1 }];
}

function setVariable(name: string, value: number): ToEvent {
  return { set_variable: { name, value } };
}

function keyManipulator(
  from: string,
  to: ToEvent,
  conditions?: Manipulator["conditions"],
): Manipulator {
  return {
    ...(conditions ? { conditions } : {}),
    from: fromKey(from),
    to: [to],
    type: "basic",
  };
}

function holdLayerManipulator(layerName: string, trigger: string): Manipulator {
  return {
    from: fromKey(trigger),
    parameters: {
      "basic.to_if_alone_timeout_milliseconds": 500,
    },
    to: [setVariable(layerName, 1)],
    to_after_key_up: [setVariable(layerName, 0)],
    to_if_alone: [toKey(trigger)], // Tap sends the trigger key itself.
    type: "basic",
  };
}

function layerMappings(
  layerName: string,
  mappings: Array<[from: string, to: ToEvent]>,
): Manipulator[] {
  const conditions = variableCondition(layerName, "variable_if");
  return mappings.map(([from, to]) => keyManipulator(from, to, conditions));
}

function fnKeyManipulator(from: string, to: ToEvent): Manipulator {
  return {
    from: fromKey(from, fnAny),
    to: [to],
    type: "basic",
  };
}

function fnModifierManipulator(from: string, to: string): Manipulator {
  return {
    from: fromKey(from, fnAny),
    to_if_other_key_pressed: [
      {
        other_keys: [
          {
            any: "key_code",
            modifiers: optionalAny,
          },
        ],
        to: [toKey(to)], // Sends the modifier passed to fnModifierManipulator.
      },
    ],
    type: "basic",
  };
}

const rules: Rule[] = [
  {
    description: "CAPS_LOCK: Escape",
    manipulators: [
      keyManipulator(
        "caps_lock",
        toKey("escape"), // Escape
        variableCondition("oe_number_layer", "variable_unless"),
      ),
    ],
  },
  {
    description: "OE: tap = ö, hold = number and navigation layer",
    manipulators: [
      holdLayerManipulator("oe_number_layer", "semicolon"),
      ...layerMappings("oe_number_layer", [
        ["caps_lock", toKey("0")], // 0
        ["a", toKey("1")], // 1
        ["s", toKey("2")], // 2
        ["d", toKey("3")], // 3
        ["f", toKey("4")], // 4
        ["g", toKey("5")], // 5
        ["h", toKey("6")], // 6
        ["j", toKey("7")], // 7
        ["k", toKey("8")], // 8
        ["l", toKey("9")], // 9
        ["y", toKey("left_arrow")], // Left Arrow; physical z on German layout
        ["u", toKey("down_arrow")], // Down Arrow
        ["i", toKey("up_arrow")], // Up Arrow
        ["o", toKey("right_arrow")], // Right Arrow
      ]),
    ],
  },
  {
    description: "CAPS_LOCK: tap = Escape, hold = Ctrl+Shift+Alt",
    enabled: false,
    manipulators: [
      {
        from: fromKey("caps_lock"),
        parameters: {
          "basic.to_if_alone_timeout_milliseconds": 100,
          "basic.to_if_held_down_threshold_milliseconds": 100,
        },
        to_if_alone: [toKey("escape")], // Escape
        to_if_held_down: [toKey("left_control", ["left_shift", "left_option"])], // Ctrl+Shift+Alt
        type: "basic",
      },
    ],
  },
  {
    description: "AE: tap = ä, hold = programming layer",
    manipulators: [
      holdLayerManipulator("ae_programming_layer", "quote"),
      ...layerMappings("ae_programming_layer", [
        ["s", toKey("8", ["right_option"])], // {
        ["d", toKey("8", ["right_shift"])], // (
        ["f", toKey("5", ["right_option"])], // [
        ["j", toKey("6", ["right_option"])], // ]
        ["k", toKey("9", ["right_shift"])], // )
        ["l", toKey("9", ["right_option"])], // }
        ["g", toKey("7", ["right_shift"])], // /
        ["b", toKey("7", ["right_option"])], // |
        ["h", toKey("7", ["right_option", "right_shift"])], // \
        ["v", toKey("backslash", ["right_shift"])], // '
        ["n", toKey("2", ["right_shift"])], // "
        ["y", toKey("close_bracket", ["right_shift"])], // *; physical z on German layout
        ["t", toKey("close_bracket")], // +
        ["u", toKey("6", ["right_shift"])], // &
        ["r", toKey("4", ["right_shift"])], // $
        ["e", toKey("0", ["right_shift"])], // =
        ["i", toKey("1", ["right_shift"])], // !
        ["o", toKey("hyphen", ["right_shift"])], // ?
        ["m", toKey("equal_sign", ["right_shift"])], // `
        ["a", toKey("non_us_backslash")], // ^
      ]),
    ],
  },
  {
    description: "CMD_R to HYPER (SHIFT+COMMAND+OPTION+CONTROL)",
    manipulators: [
      {
        from: fromKey("right_command", {}),
        to: [toKey("left_shift", ["left_command", "left_control", "left_option"])], // Hyper
        type: "basic",
      },
      {
        from: {
          description:
            "Avoid starting sysdiagnose with the built-in macOS shortcut cmd+shift+option+ctrl+/",
          key_code: "slash",
          modifiers: hyper,
        },
        to: [],
        type: "basic",
      },
      {
        description: "Hyper+< sends Ctrl+B then n for tmux next-window",
        from: fromKey("grave_accent_and_tilde", hyper),
        to: [
          toKey("b", ["left_control"]), // Ctrl+B
          toKey("n"), // n
        ],
        type: "basic",
      },
    ],
  },
  {
    description: "Right Ctrl => FN (for Glove80 Apple fn key hack)",
    manipulators: [
      {
        from: fromKey("right_control", {}),
        to: [toKey("fn")], // Fn
        type: "basic",
      },
    ],
  },
  {
    description: "FnMate: Fn navigation, scrolling, and mouse clicks",
    manipulators: [
      fnModifierManipulator("a", "left_shift"),
      fnModifierManipulator("s", "left_control"),
      fnModifierManipulator("d", "left_option"),
      fnModifierManipulator("f", "left_command"),
      fnKeyManipulator("h", toKey("left_arrow")), // Left Arrow
      fnKeyManipulator("l", toKey("right_arrow")), // Right Arrow
      fnKeyManipulator("j", toKey("down_arrow")), // Down Arrow
      fnKeyManipulator("k", toKey("up_arrow")), // Up Arrow
      fnKeyManipulator("spacebar", toKey("return_or_enter")), // Return
      fnKeyManipulator("b", toKey("delete_or_backspace")), // Backspace
      fnKeyManipulator("n", toKey("tab")), // Tab
      fnKeyManipulator("y", { mouse_key: { vertical_wheel: 32 } }),
      fnKeyManipulator("o", { mouse_key: { vertical_wheel: -32 } }),
      fnKeyManipulator("u", { mouse_key: { horizontal_wheel: -32 } }),
      fnKeyManipulator("i", { mouse_key: { horizontal_wheel: 32 } }),
      fnKeyManipulator("comma", { pointing_button: "button1" }),
      fnKeyManipulator("period", { pointing_button: "button2" }),
    ],
  },
];

const config = {
  global: { unsafe_ui: true },
  profiles: [
    {
      complex_modifications: { rules },
      devices: [
        {
          identifiers: {
            is_keyboard: true,
            product_id: 668,
            vendor_id: 76,
          },
          simple_modifications: [
            {
              from: {
                consumer_key_code: "al_terminal_lock_or_screensaver",
              },
              to: [
                {
                  key_code: "vk_none",
                },
              ],
            },
          ],
        },
      ],
      name: "Default profile",
      selected: true,
      virtual_hid_keyboard: {
        country_code: 0,
        keyboard_type_v2: "ansi",
      },
    },
  ],
};

await Deno.writeTextFile(karabinerJsonPath, `${JSON.stringify(config, null, 4)}\n`);
