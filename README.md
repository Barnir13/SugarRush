# SugarRush

2D platformer játék Godot 4-ben készítve.

## Futtatás

A játék a `Builds` mappában található `.exe` fájllal indítható.

## Fejlesztői környezet

- Godot 4.6.1

## Projekt struktúra

- `Assets/` → assetek, spriteok, animációk
- `Scripts/` → GDScript fájlok
- `Sprites/` → Saját Spriteok, Aseprite-ban készítve
- `Builds/` → exportált játék build

## Verziókezelés

A projekt GitHub verziókezelést használ.

## Forrásból futtatás

Ha nem csak a kész build-et akarod kipróbálni, hanem szerkesztened is: telepítsd a Godot 4.6.1-et, nyisd meg a Project Manager-ben a `project.godot` fájlt, aztán F5.

## Fordítás

Project → Export... menüben két preset van beállítva, Windows és Web. Windows-hoz kelleni fognak az export templates, ha még nincsenek meg (Editor → Manage Export Templates).

## Irányítás

A/D mozgás, Space ugrás, S lemászás one-way platformról, E interakció, ESC pause.
