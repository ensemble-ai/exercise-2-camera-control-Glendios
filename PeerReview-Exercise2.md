# Peer-Review for Programming Exercise 2

## Description

For this assignment, you will be giving feedback on the completeness of assignment two: Obscura. To do so, we will give you a rubric to provide feedback. Please give positive criticism and suggestions on how to fix segments of code.

You only need to review code modified or created by the student you are reviewing. You do not have to check the code and project files that the instructor gave out.

Abusive or hateful language or comments will not be tolerated and will result in a grade penalty or be considered a breach of the UC Davis Code of Academic Conduct.

If there are any questions at any point, please email the TA.

## Due Date and Submission Information

See the official course schedule for due date.

A successful submission should consist of a copy of this markdown document template that is modified with your peer review. This review document should be placed into the base folder of the repo you are reviewing in the master branch. The file name should be the same as in the template: `CodeReview-Exercise2.md`. You must also include your name and email address in the `Peer-reviewer Information` section below.

If you are in a rare situation where two peer-reviewers are on a single repository, append your UC Davis user name before the extension of your review file. An example: `CodeReview-Exercise2-username.md`. Both reviewers should submit their reviews in the master branch.

# Solution Assessment

## Peer-reviewer Information

- _name:_ Patrick Le
- _email:_ plele@ucdavis.edu

### Description

For assessing the solution, you will be choosing ONE choice from: unsatisfactory, satisfactory, good, great, or perfect.

The break down of each of these labels for the solution assessment.

#### Perfect

    Can't find any flaws with the prompt. Perfectly satisfied all stage objectives.

#### Great

    Minor flaws in one or two objectives.

#### Good

    Major flaw and some minor flaws.

#### Satisfactory

    Couple of major flaws. Heading towards solution, however did not fully realize solution.

#### Unsatisfactory

    Partial work, not converging to a solution. Pervasive Major flaws. Objective largely unmet.

---

## Solution Assessment

### Stage 1

- [x] Perfect
- [ ] Great
- [ ] Good
- [ ] Satisfactory
- [ ] Unsatisfactory

---

#### Justification

The position lock works percetly fine. Also it still works during hyper speed and the user is able to zoom in and zoom out. As for the code it's strange to see a boundry check in it since the camera just needs to be centered on the vessel.

---

### Stage 2

- [x] Perfect
- [ ] Great
- [ ] Good
- [ ] Satisfactory
- [ ] Unsatisfactory

---

#### Justification

The auto scroller works perfect as well. The player is unable to move outside the bounds of the box and the autoscroll
function is working. When the player is against the left side of the box the vessle is push along. As for the code it is simple
and easy to follow.

---

### Stage 3

- [ ] Perfect
- [ ] Great
- [x] Good
- [ ] Satisfactory
- [ ] Unsatisfactory

---

#### Justification

The camera does work however there are some major issues. Such as the speed and distance the camera follows the player.
When the player moves the camera seems to move instantly after it. Adjustments to make the leash distance longer could help
with this issue. Also the camera does not center on the player after it moves. The vessle is jittering during movement and the movement
does not feel smooth.

---

### Stage 4

- [ ] Perfect
- [x] Great
- [ ] Good
- [ ] Satisfactory
- [ ] Unsatisfactory

---

#### Justification

The camera does work and the movement of the camera is smooth. However the vessel does seem to jitter like stage 3
The player is able to move ahead of the camera a certain distance before moving woards the player. The only issue I see the that the timer for the camera to recenter on the
vessle after not moving is too long. The code is easy to follow and read.

---

### Stage 5

- [ ] Perfect
- [x] Great
- [ ] Good
- [ ] Satisfactory
- [ ] Unsatisfactory

---

#### Justification

The camera does function with it speeding up when the vessel is in the speeding up zone.
Also once the player is at the edge of the outbox it properly pushes the whole box.
A minor issue is that the outer box is a rectangle which leads to the top and bottom speed up zones not having the same area as the left
and right. The code is easy to and has very useful comments.

---

# Code Style

### Description

Check the scripts to see if the student code adheres to the GDScript style guide.

If sections do not adhere to the style guide, please peramlink the line of code from Github and justify why the line of code has not followed the style guide.

It should look something like this:

- [description of infraction](https://github.com/dr-jam/ECS189L) - this is the justification.

Please refer to the first code review template on how to do a permalink.

#### Style Guide Infractions

- [There should be a space after the colon](https://github.com/ensemble-ai/exercise-2-camera-control-Glendios/blob/67b5555776edfb6f0b8f99c110f41e681b319549/Obscura/scripts/camera_controllers/position_lock_camera.gd#L5)
  when declaring the variables.
- [There should not be a new line here](https://github.com/ensemble-ai/exercise-2-camera-control-Glendios/blob/67b5555776edfb6f0b8f99c110f41e681b319549/Obscura/scripts/camera_controllers/lerp_smooth_camera.gd#L36). It should be instead all on the same line since
  you are subtracting them to find the movement.

#### Style Guide Exemplars

- [The lines between each function is properly spaced](https://github.com/ensemble-ai/exercise-2-camera-control-Glendios/blob/8848b2e2cd55fa2972955fa1e9b967070bb43e82/Obscura/scripts/camera_controllers/speed_push_camera.gd#L24)
- [Comments are properly formated with a space and capital first letter](https://github.com/ensemble-ai/exercise-2-camera-control-Glendios/blob/8848b2e2cd55fa2972955fa1e9b967070bb43e82/Obscura/scripts/camera_controllers/lock_lerp_camera.gd#L20)
- [Proper indentation for if statements](https://github.com/ensemble-ai/exercise-2-camera-control-Glendios/blob/8848b2e2cd55fa2972955fa1e9b967070bb43e82/Obscura/scripts/camera_controllers/lerp_smooth_camera.gd#L33)

---

# Best Practices

### Description

If the student has followed best practices then feel free to point at these code segments as examplars.

If the student has breached the best practices and has done something that should be noted, please add the infraction.

This should be similar to the Code Style justification.

#### Best Practices Infractions

- [Redundant code](https://github.com/ensemble-ai/exercise-2-camera-control-Glendios/blob/8848b2e2cd55fa2972955fa1e9b967070bb43e82/Obscura/scripts/camera_controllers/position_lock_camera.gd#L25) checking for boundary for the postition lock camera class. This is unessary since the camera just needs to be set/locked on to the postion of the vessel.

#### Best Practices Exemplars

- [Detailed naming of variables.](https://github.com/ensemble-ai/exercise-2-camera-control-Glendios/blob/8848b2e2cd55fa2972955fa1e9b967070bb43e82/Obscura/scripts/camera_controllers/lerp_smooth_camera.gd#L10)
  Can clearly understand what each variables is and does.
- [Detailed comments](https://github.com/ensemble-ai/exercise-2-camera-control-Glendios/blob/8848b2e2cd55fa2972955fa1e9b967070bb43e82/Obscura/scripts/camera_controllers/lerp_smooth_camera.gd#L51) to help follow along with the code. They are not too long
  and stright to the point in explaining the code.
- [Great seperation between functions](https://github.com/ensemble-ai/exercise-2-camera-control-Glendios/blob/67b5555776edfb6f0b8f99c110f41e681b319549/Obscura/scripts/camera_controllers/speed_push_camera.gd#L53). This
  makes it much easier to follow along.
