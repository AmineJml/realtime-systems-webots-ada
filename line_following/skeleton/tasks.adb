with Ada.Text_IO;   use Ada.Text_IO;
with Ada.Real_Time; use Ada.Real_Time;
with System;
with Webots_API;    use Webots_API;

package body Tasks is
  -- Main goal - follow black loine
  -- on the side we will have objects/obstacles moving around, we need to detect them, and halt if an abstacle is too close

  --  • A task MotorControlTask that only takes care of setting the speeds
  --  of the motors.
  --  • A task LineFollowingTask that reads the light sensors and sends
  --  commands to MotorControlTask.
  --  • A task DistanceTask that reads the distance sensor and sends com-
  --  mands to MotorControlTask.
  --  • A task DisplayTask that displays some status information.

  type direction is (goStraight, goLeft, goRight, Stop);

  protected CarState is
    function direction_get (id : out direction) return direction;
    procedure direction_put (id : in direction);

  private
    direction_togo : direction;
  end CarState;

  protected body CarState is
    -- procedures can modify the data
    function direction_get(id : out direction) return direction is
    begin
      return id;
    end direction_get;

    procedure direction_put (id : in direction) is
    begin
      direction_togo := id;
    end direction_put;

  end CarState;

  -----------------------------
  --   LineFollowingTask     --
  -----------------------------
  task LineFollowingTask is
  end LineFollowingTask;

  task body LineFollowingTask is
    LS1_light_value : Integer;
    LS2_light_value : Integer;
    LS3_light_value : Integer;

      Next_Time     : Time := Time_Zero;
    --line_delay : Duration := 100;
  begin
    loop
      LS1_light_value := read_light_sensor (LS2);
      LS2_light_value := read_light_sensor (LS2);
      LS3_light_value := read_light_sensor (LS2);

      if LS1_light_value in 250 .. 350 then
        CarState.direction_put (goStraight);
        Put_Line ("Light Sensors - send go straight");
      else
        CarState.direction_put (Stop);
        Put_Line ("Light Sensors - STOP");

      end if;

      next_time := next_time + Period_Display;
      delay until Next_Time;

      exit when simulation_stopped;
    end loop;
  end LineFollowingTask;

  -----------------------------
  -- Motor Control Task -------
  -----------------------------
  task MotorControlTask is
  end MotorControlTask;

  task body MotorControlTask is
  begin
    loop

      exit when simulation_stopped;
    end loop;
  end MotorControlTask;

  -- Background procedure required for package
  procedure Background is
  begin
    while not simulation_stopped loop
      delay 0.25;
    end loop;
  end Background;

end Tasks;
