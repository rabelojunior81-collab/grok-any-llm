#!/usr/bin/env bats
# gall.bats — TDD bats para o shim gall.sh
# License: MIT (c) 2026 Adilson Rabelo Junior / Rabelus Lab

setup() {
  GALL="$BATS_CWD/../../src/gall.sh" 2>/dev/null || GALL="$PWD/../src/gall.sh"
  export FAKE_KEY="sk-fake-test-key-1234567890"
}

@test "reconhece provider or em --dry-run" {
  export OPENROUTER_API_KEY="$FAKE_KEY"
  run bash "$GALL" or --dry-run
  [ "$status" -eq 0 ]
  echo "$output" | grep -q 'provider=or'
  echo "$output" | grep -q 'GROK_HOME'
}

@test "reconhece --model X em --dry-run" {
  export KILO_API_KEY="$FAKE_KEY"
  run bash "$GALL" kilo --model z-ai/glm-5.2 --dry-run
  [ "$status" -eq 0 ]
  echo "$output" | grep -q 'provider=kilo'
  echo "$output" | grep -q 'GROK_DEFAULT_MODEL=z-ai/glm-5.2'
}

@test "erro claro quando key do provider ausente" {
  unset OPENCODE_GO_API_KEY
  run bash "$GALL" oc --dry-run
  [ "$status" -eq 3 ]
  echo "$output" | grep -q 'OPENCODE_GO_API_KEY'
}
