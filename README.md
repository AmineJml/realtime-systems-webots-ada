# Real-Time Robot Control in Ada (Webots)

This repository contains a real-time robotics control system developed in **Ada** using the **Webots e-puck simulator**. The project implements both **event-driven** and **periodic real-time scheduling** for manual control, autonomous line following, and obstacle-aware distance regulation.

> **Authorship & Scope of Work (Transparency Statement)**
> This project is built on top of an **official Webots + Ada skeleton provided by the course instructors**.
> **All real-time control logic was implemented by me exclusively in:**
>
> * `tasks.ads`
> * `tasks.adb`
>
> All other files (e.g., `main.adb`, `webots_api.ads`, `webots_api.adb`) remain **unchanged** from the original skeleton and were not authored by me.

---

## Project Features

### Event-Driven Manual Control

* Keyboard-based directional control.
* Immediate reaction to key press/release events.
* Black line detection using light sensors.
* Robot **automatically stops at boundaries** and cannot cross the line.

### Autonomous Line Following

* Uses **three ground-facing light sensors**.
* Follows the track in **both clockwise and counter-clockwise directions**.
* Continuous sensor feedback with real-time correction.

### Obstacle-Aware Distance Control

* Uses **front distance sensors**.
* Dynamically slows down or stops when approaching an obstacle.
* Maintains a visible safe distance behind moving objects.

### Real-Time Architecture

* Ada **tasks with priorities**
* **Event driven scheduling** (Part 2)
* **Periodic scheduling** (Part 3)
* **Protected objects** for safe inter-task communication
* Strict separation between:

  * Sensing
  * Decision logic
  * Motor control
  * Display/status reporting

---

## Tech Stack

* **Language:** Ada
* **Simulator:** Webots (e-puck robot)
---

## How to Run

1. Open Webots and load the world:

   ```
   e-puck/worlds/e-puck_line.wbt
   ```
2. Build the controller inside Webots.
3. Compile the Ada controller:

   ```bash
   gnatmake main.adb
   ```
4. Start the Webots simulation.
5. Run:

   ```bash
   ./main
   ```
---

## Simulation Screenshots

## Learning Outcomes

* Practical implementation of **real-time embedded scheduling**
* Event vs periodic task comparison
* Sensor-based closed-loop control
* Safe concurrent programming using **Ada protected objects**
* Robotics control in a simulated embedded environment

---
