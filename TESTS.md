# Tesztesetek

## 1. Main menu indítás

Lépések:
- A játék elindítása
- Start gomb megnyomása

Elvárt eredmény:
- A pálya betöltődik

Tényleges eredmény:
- A pálya sikeresen betöltődik

Státusz:
- Sikeres


## 2. Player mozgás

Lépések:
- Balra és jobbra mozgás billentyűkkel

Elvárt eredmény:
- A player mozog mindkét irányba

Tényleges eredmény:
- A player megfelelően mozog

Státusz:
- Sikeres


## 3. Ugrás rendszer

Lépések:
- Jump gomb megnyomása

Elvárt eredmény:
- A player ugrik

Tényleges eredmény:
- Az ugrás megfelelően működik

Státusz:
- Sikeres


## 4. Enemy collision

Lépések:
- A player oldalról hozzáér egy enemyhez

Elvárt eredmény:
- A player meghal
- A pálya újratöltődik

Tényleges eredmény:
- A player meghal és a pálya újratöltődik

Státusz:
- Sikeres


## 5. Enemy stomp rendszer

Lépések:
- A player az enemy fejére ugrik

Elvárt eredmény:
- Az enemy meghal
- A player visszapattan

Tényleges eredmény:
- Az enemy meghal és a player visszapattan

Státusz:
- Sikeres

## 6. Checkpoint rendszer

Lépések:
- A player eléri a checkpointot
- A player meghal

Elvárt eredmény:
- A player a checkpointnál spawnol újra

Tényleges eredmény:
- A player a checkpointnál spawnol újra

Státusz:
- Sikeres

## 7. Leesés a pályáról

Lépések:
- A player leesik a pályáról

Elvárt eredmény:
- A pálya újratöltődik
- A player újraspawnol

Tényleges eredmény:
- A pálya újratöltődik és a player újraspawnol

Státusz:
- Sikeres


## 8. Invincibility powerup

Lépések:
- A player felveszi az invincibility powerupot
- Enemyhez ér

Elvárt eredmény:
- A player át tud menni az enemyken
- A player nem hal meg

Tényleges eredmény:
- A player át tud menni az enemyken és nem hal meg

Státusz:
- Sikeres


## 9. Double jump powerup

Lépések:
- A player felveszi a double jump powerupot
- Kétszer ugrik levegőben

Elvárt eredmény:
- A player dupla ugrást tud végrehajtani

Tényleges eredmény:
- A dupla ugrás megfelelően működik

Státusz:
- Sikeres


## 10. Powerup reset halál után

Lépések:
- A player felvesz egy powerupot
- Meghal mielőtt lejárna az idő

Elvárt eredmény:
- A powerup hatása megszűnik respawn után

Tényleges eredmény:
- A powerup hatása megszűnik respawn után

Státusz:
- Sikeres


## 11. Breaking platform rendszer

Lépések:
- A player rááll egy breaking platformra
- Vár néhány másodpercet

Elvárt eredmény:
- A platform eltűnik/breakel

Tényleges eredmény:
- A platform megfelelően eltűnik

Státusz:
- Sikeres


## 12. Spike collision

Lépések:
- A player hozzáér egy tüskéhez

Elvárt eredmény:
- A player meghal
- A pálya újratöltődik

Tényleges eredmény:
- A player meghal és a pálya újratöltődik

Státusz:
- Sikeres


## 13. Moving platform drop-through

Lépések:
- A player rááll egy moving platformra
- Az S billentyű megnyomása

Elvárt eredmény:
- A player leesik a platformról

Tényleges eredmény:
- A player megfelelően leesik a platformról

Státusz:
- Sikeres