
## Background

This was the term project for a Cost Benefit Analysis course taught by Dr. Christopher Costello in 2024 at UCSB's Bren School. We were given the opportunity to conduct some component of cost benefit analysis on a problem of our choice. At the time, my mind wasn't on actual environmental problems, but rather the inefficiencies of project planning.

I was surprised to learn that none of my peers or professors had heard of the term "agile frameworks", and I figured that environmental professionals could benefit from learning about these new methods of managing projects. I specifically chose to look at SCRUM, because it seemed to be the most widely used among Tech people and the most portable to environmental projects (such as the Group Capstone Project I was working on at the time -- link here https://github.com/rkanderson/sumatra-surf-conservation)  

Within this topic, I chose to specifically hone in on the issue of the tradeoff between planning and taking immediate action, and to model that quantitatively -- realizing that being able to quantify time lost or gained would be able to factor well into cost benefit analysis. In fact, I chose to base all the model parameters off of the Bren School Group Projects. Why? Because all of us were working on them at the time, but also these were projects that were all given the same timeline to work in the same stages on the same things... for example-- every group spent the first quarter producing an action plan for the remainder of their year-long project.

I and many other groups felt like their action plan wasn't that useful --- we relied on a lot of guesswork, and some things we were only able to find out by actually attempting them.

Thus I hypothesized I could model the "usefulness" of a plan as an exponential decay function.

$$ u_{t+1} = ru_t$$

Where $u$ is the usefulness of the plan, and $r$ is a decay rate between 0 and 1.

The usefulness variable would be used when determining the time duration to complete a task at period t. We would model this duration as:

$$ D_t = B(1-pu_t) $$

Where $D$ is the duration, $B$ is the base duration (the duration if there were no plan), and $p$ is a planning effectiveness parameter between 0 and 1. The idea is that p would represent the proportion of a task that could be improved by a perfect plan (perfect meaning maximal usefulness).

NOTE: when performing this calculation, t is reset to "time since last plan was made", instead of the raw time period, that way the plan can be "refreshed" to reset it to maximual usefulness.

I then went ahead and modeled the overhead time associated with creating a plan as follows:

$$ L = c\sigma + k$$

L is the total amount of time required to plan, \sigma represents the scope of time that plan would apply to. c and k are constants representing the variable and fixed costs of planning, respectively. I chose a linear function for simplicity. 

In the case of Bren Capstone projects and perhaps other projects in non-profit, government, and some companies, the scope of the plan is a large portion of the project time, most if not all planning is done up front and the usefulness quantity would continuously decay.

But SCRUM would introduce a tradeoff of more frequent planning with lower time scopes. The usefulness of the plan would be refreshed each time, but people would need to take time to plan more frequently (this is exactly what happens in sprint review meetings -- somithng that could be hard to convince workers so set on the old ways to do.)

## Shiny App
I build a shinyapp where you can tweak all the variables to simulate a project, visualizing the total person-hours over the weeks.

https://rkanderson.shinyapps.io/scrum_project_planning_tradeoff_model/

## Results

I discuss results in my slide deck presentation here. I do the stochastic modeling with a set of parameters I deemed realistic based on the Bren group project (Slide 5)

https://docs.google.com/presentation/d/1El0y97HjurRNVl77n8ZyXXEB2do57aIJoinLDRqrfOg/edit?slide=id.g31a9226fd74_0_571#slide=id.g31a9226fd74_0_571

Results are provided beginning on page 7.

With no other information, planning for the max duration is most likely to save the most time (opposite of what I expected)
None of the planning scopes came out as superior to the others → result sensitive to project and team factors
The distributions appear bimodal for the smaller scope values → interesting to find out why since it could have a strong effect on the ideal planning scope.


This was a little shocking, because in these cases, the plan decayed to a "useless" near zero level for most of the projects duration. So it seemed that in this simulation, a project may have been better off having no plan at all.

So this leads me to hypothesize something, opening up some room for new tests:
- Maybe the time required to make a plan is not linear with its scope length -- but rather exponential. Indeed, I had taken the huge hour count needed for 10 weeks worth of planning. If you scaled that down linearly to the scopes that scrum teams use, it's far more. So I think there is some non-linearity worth investigating. Exponential seems logical to me because there are more interactions between different components of the projects that could occur and. need to be accounted for.

## Exploration documents
where you can see the process unfold
- [ex1-develop-basic-model](explorations/ex1-develop-basic-model.html)
- [ex3.1-tests-of-various-scopes-under-single-set-of-paramms](explorations/ex3.1-tests-of-various-scopes-under-single-set-of-paramms.html)
- [ex4-analyzing-the-param-combo-run-data](explorations/ex4-analyzing-the-param-combo-run-data.html)


