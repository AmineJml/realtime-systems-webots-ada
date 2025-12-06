# Real-Time Robot Control in Ada (Webots)

This repository contains a real-time robotics control system developed in **Ada** using the **Webots e-puck simulator**. The project implements both **event-driven** and **periodic real-time scheduling** for manual control, autonomous line following, and obstacle-aware distance regulation.

> **Authorship & Scope of Work (Transparency Statement)**
> This project is built on top of an **official Webots + Ada skeleton provided by the course instructors**.
> **All real-time control logic was implemented by me in:**
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
* Obstacle detection and real time reaction (halting when obstacles are detected).

### Real-Time Architecture

* Ada **tasks with priorities**
* **Event driven scheduling**
* **Periodic scheduling**
* **Protected objects** for safe inter-task communication
* Strict separation between:

  * Sensing
  * Decision logic
  * Motor control
  * Display/status reporting

---

## Tech Stack

* **Language:** Ada, C (used by Webots and its low-level controller interface)
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
## 🖼️ Simulation Screenshots

### Event-Driven Manual Control (Keyboard)

![Manual Control 1](images/Screenshot%20from%202025-12-06%2013-29-23.png)
![Manual Control 2](images/Screenshot%20from%202025-12-06%2013-30-08.png)

These screenshots show the robot being manually controlled using keyboard input with real-time event-driven scheduling and automatic black line stopping.

---

### Autonomous Line Following (Periodic Scheduling)

![Line Following 1](images/Screenshot%20from%202025-12-06%2013-31-43.png)
![Line Following 2](images/Screenshot%20from%202025-12-06%2013-31-56.png)

These screenshots show the robot autonomously following the black track using periodic sensor sampling and closed-loop motor control.


## Learning Outcomes

* Practical implementation of **real-time embedded scheduling**
* Event vs periodic task comparison
* Sensor based and closed loop control
* Safe concurrent programming using **Ada protected objects**
* Robotics control in a simulated embedded environment

---
