with Ada.Text_IO;   use Ada.Text_IO;
with Ada.Real_Time; use Ada.Real_Time;
with System;
with Webots_API;    use Webots_API;

package body Tasks is

   type EventID is
     (UpPressed, DownPressed, LeftPressed, RightPressed, ReleaseEvent);

   -----------------------------
   -- Event --------------------
   -----------------------------
   protected Event is
      entry Wait (id : out EventID);
      procedure Signal (id : in EventID);
   private
      current_id : EventID;
      signalled  : Boolean := False;
   end Event;

   protected body Event is
      entry Wait (id : out EventID) when signalled is
      begin
         id := current_id;
         signalled := False;
      end Wait;

      procedure Signal (id : in EventID) is
      begin
         current_id := id;
         signalled := True;
      end Signal;
   end Event;

   -----------------------------
   -- Event Dispatcher Task ----
   -----------------------------
   task EventDispatcherTask is
   end EventDispatcherTask;

   task body EventDispatcherTask is
      Next_Time     : Time := Time_Zero;

      Now_Up        : Boolean;
      Now_Down      : Boolean;
      Now_Left      : Boolean;
      Now_Right     : Boolean;

      Prev_Up        : Boolean := False;
      Prev_Down      : Boolean := False;
      Prev_Left      : Boolean := False;
      Prev_Right     : Boolean := False;

      Now_light : Integer;

   begin

      loop
         Now_Up := button_pressed (UpButton);
         Now_Down := button_pressed (DownButton);
         Now_Right := button_pressed (RightButton);
         Now_Left := button_pressed (LeftButton);

         Now_light := read_light_sensor(LS2);

         if Now_light in 250 .. 350 then
            Event.Signal(ReleaseEvent);
            Put_Line ("Blackline Reached, please exit the simulation or manually move the bot!");

         elsif (Now_Up /= Prev_Up) then
            if Now_Up then
               Event.Signal (UpPressed);
            else
               Event.Signal (ReleaseEvent);
            end if;
         elsif (Now_Down  /= Prev_Down) then
            if Now_Down then
               Event.Signal (DownPressed);
            else
               Event.Signal (ReleaseEvent);
            end if;
         elsif (Now_Right /= Prev_Right) then
            if Now_Right then
               Event.Signal (RightPressed);
            else
               Event.Signal (ReleaseEvent);
            end if;
         elsif (Now_Left /= Prev_Left) then
             if Now_Left then
               Event.Signal (LeftPressed);
            else
               Event.Signal (ReleaseEvent);
            end if;
         end if;

         Prev_Up := Now_Up;
         Prev_Left   := Now_Left;
         Prev_Right := Now_Right;
         Prev_Down := Now_Down;

         Next_Time := Next_Time + Period_Display;
         delay until Next_Time;
      end loop;
   end EventDispatcherTask;

   -----------------------------
   -- Motor Control Task -------
   -----------------------------
   task MotorControlTask is
   end MotorControlTask;

   task body MotorControlTask is
      ButtonID : EventID;
   begin
      loop
         Event.Wait (ButtonID);  -- noothing until an event occurs

         case ButtonID is
            when UpPressed    =>
               set_motor_speed (LeftMotor, 600);
               set_motor_speed (RightMotor, 600);

            when DownPressed  =>
               set_motor_speed (LeftMotor, -500);
               set_motor_speed (RightMotor, -500);

            when LeftPressed  =>
               set_motor_speed (LeftMotor, 0);
               set_motor_speed (RightMotor, 300);

            when RightPressed =>
               set_motor_speed (LeftMotor, 300);
               set_motor_speed (RightMotor, 0);

            when ReleaseEvent    =>
               set_motor_speed (LeftMotor, 0);
               set_motor_speed (RightMotor, 0);
         end case;

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
