# Tesztelési dokumentáció

## Tesztelési megközelítés

A projekt tesztelése Play Mode alapú manuális unit és integrációs tesztekkel történt Godot engine környezetben.

## UNIT TESZTEK

## 1. Player mozgás

Lépések:
- Balra/jobbra mozgás billentyűkkel

Elvárt eredmény:
- A player megfelelően mozog mindkét irányba

Eredmény:
- Sikeres

## 2. Ugrás rendszer

Lépések:
- Jump input megnyomása

Elvárt eredmény:
- A player felugrik a levegőbe

Eredmény:
- Sikeres

## 3. Invincibility powerup

Lépések:
- A player felveszi az invincibility powerupot
- Enemyhez ér

Elvárt eredmény:
- A player nem sebződik
- Át tud menni az enemyken

Eredmény:
- Sikeres

## 4. Double jump rendszer

Lépések:
- A player felveszi a double jump powerupot
- Ugrás a levegőben másodszor is

Elvárt eredmény:
- A player két ugrást tud végrehajtani a levegőben

Eredmény:
- Sikeres

## 5. Speed boost rendszer

Lépések:
- A player felveszi a speed boost powerupot
- Mozgás jobbra/balra

Elvárt eredmény:
- A player gyorsabban mozog a normál sebességnél

Eredmény:
- Sikeres

## 6. Respawn alap működés

Lépések:
- A player leesik a pályáról

Elvárt eredmény:
- A GameManager respawnolja a playert
- A player visszakerül az indulási pozícióba vagy checkpointhoz

Eredmény:
- Sikeres

## 7. Checkpoint aktiválás

Lépések:
- A player eléri a checkpointot

Elvárt eredmény:
- A checkpoint elmentődik GameManager-ben
- Halál után oda spawnol vissza a player

Eredmény:
- Sikeres

## INTEGRÁCIÓS TESZTEK

## 8. Checkpoint + Respawn rendszer

Lépések:
- A player aktiválja a checkpointot
- A player meghal

Elvárt eredmény:
- GameManager elmenti a checkpoint pozíciót
- Scene reload után a player a checkpointnál spawnol

Eredmény:
- Sikeres

## 9. Enemy + Player collision

Lépések:
- A player oldalról hozzáér egy enemyhez

Elvárt eredmény:
- A player meghal
- A pálya újratöltődik

Eredmény:
- Sikeres

## 10. Powerup + enemy layer rendszer

Lépések:
- A player felveszi az invincibility powerupot
- Enemyhez ér

Elvárt eredmény:
- A player átmegy az enemyken
- Nem történik halál

Eredmény:
- Sikeres

## 11. Scene reload + world reset

Lépések:
- A player meghal (pl. leesik a pályáról vagy enemy által)

Elvárt eredmény:
- A scene újratöltődik
- Az enemyk és collectablek újra spawnolnak
- A játék állapota alaphelyzetbe kerül, kivéve a checkpointot

Eredmény:
- Sikeres