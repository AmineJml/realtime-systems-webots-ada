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
      function direction_get return direction;
      procedure direction_put (curDirection : in direction);

      function halt_get return Boolean;
      procedure halt_put (curHalt : in Boolean);
   private
      direction_togo : direction;
      halt : Boolean := False;
   end CarState;

   protected body CarState is
      -- procedures can modify the data
      function direction_get return direction is
      begin
         return direction_togo;
      end direction_get;

      procedure direction_put (curDirection : in direction) is
      begin
         direction_togo := curDirection;
      end direction_put;

      function halt_get return Boolean is
      begin
         return halt;
      end halt_get;

      procedure halt_put (curHalt : in Boolean) is
      begin
         halt := curHalt;
      end halt_put;

   end CarState;

   -----------------------------
   --DisplayTask----------------
   -----------------------------
   task DisplayTask is
   end DisplayTask;

   task body DisplayTask is
      halt : Boolean;
      curDirection : direction;

      Next_Time : Time := Time_Zero;
   begin
      loop
         halt := CarState.halt_get;
         curDirection := CarState.direction_get;
            Put_Line ("==========================================");

         Put ("Any objects nearby? - ");
         if halt then
            Put_Line ("Objects - Halting, please remove object");
         else
            Put_Line ("No Objects");
         end if;

         curDirection := CarState.direction_get;
         Put ("Current Direction - ");
         if curDirection = goStraight then
            Put_Line ("Straight");
         elsif curDirection = goLeft then
            Put_Line ("Left");
         elsif curDirection = goRight then
            Put_Line ("Right");
         elsif curDirection = Stop then
            Put_Line ("No black line detected - Going Nowhere");
         end if;
            Put_Line ("==========================================");


         next_time := next_time + Period_Display * 10;
         delay until Next_Time;

         exit when simulation_stopped;
      end loop;
   end DisplayTask;


    -----------------------------
   --   DistanceTask     --
   -----------------------------
   task DistanceTask is
   end DistanceTask;

   task body DistanceTask is
      DistanceValue : Integer;

      Next_Time : Time := Time_Zero;
      --line_delay : Duration := 100;
   begin
      loop
         DistanceValue := read_distance_sensor;
         if (DistanceValue > 100) then
            CarState.halt_put (True);
         else
            CarState.halt_put (False);
         end if;
         next_time := next_time + Period_Display*2;
         delay until Next_Time;

         exit when simulation_stopped;
      end loop;
   end DistanceTask;


   -----------------------------
   --   LineFollowingTask     --
   -----------------------------
   task LineFollowingTask is
   end LineFollowingTask;

   task body LineFollowingTask is
      LS1_light_value : Integer;
      LS2_light_value : Integer;
      LS3_light_value : Integer;

      Next_Time : Time := Time_Zero;
   begin
      loop
         LS1_light_value := read_light_sensor (LS1);
         LS2_light_value := read_light_sensor (LS2);
         LS3_light_value := read_light_sensor (LS3);


         if (LS2_light_value in 250 .. 320) then
            CarState.direction_put (goStraight);

         elsif (LS1_light_value not in 250 .. 320) then
            CarState.direction_put (goRight);

         elsif (LS3_light_value not in 250 .. 320) then
            CarState.direction_put (goLeft);
         else
            -- or obstacle
            CarState.direction_put (Stop);
         end if;

         next_time := next_time + (Period_Display*3)/2;
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
      togo : direction;
            tohalt :Boolean;
            Next_Time : Time := Time_Zero;

   begin
      loop
         togo := CarState.direction_get;
         tohalt := CarState.halt_get;

         if (tohalt) then
            set_motor_speed (LeftMotor, 0);
            set_motor_speed (RightMotor, 0);
         elsif (togo = goStraight) then
            set_motor_speed (LeftMotor, 500);
            set_motor_speed (RightMotor, 500);

         elsif (togo = goLeft) then
            set_motor_speed (LeftMotor, 0);
            set_motor_speed (RightMotor, 500);
         elsif (togo = goRight) then
            set_motor_speed (LeftMotor, 500);
            set_motor_speed (RightMotor, 0);
         else
            set_motor_speed (LeftMotor, 0);
            set_motor_speed (RightMotor, 0);
         end if;

         next_time := next_time + Period_Display;
         delay until Next_Time;
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
