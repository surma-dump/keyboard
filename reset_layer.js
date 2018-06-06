const fs = require('fs');

const config = JSON.parse(fs.readFileSync('./config.json'));

config.keyboard.keys.forEach(key => {
  // Reset layer 1
  const keycode = key.keycodes[1];
  const matchers = [
    /^RESET$/i,
    /_F[0-9]*$/i,
  ]
  if(matchers.some(matcher => matcher.test(keycode.id))) {
    return key;
  }

  keycode.id = "KC_TRNS";
  return key;
});

fs.writeFileSync('./config.json', JSON.stringify(config));
