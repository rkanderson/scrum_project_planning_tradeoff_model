
# SCRUM Project Planning Tradeoff Model

## Background

This project was the **term project for a Cost Benefit Analysis course** taught by Dr. Christopher Costello in 2024 at UCSB's Bren School. Students were invited to apply cost-benefit analysis to a problem of their choice. I chose to focus on **inefficiencies in project planning**, particularly within environmental projects, as I realized few of my peers or professors were familiar with **agile frameworks**.

I specifically examined **SCRUM** because it is widely used in tech and could be applied to environmental projects, such as the [Bren School Group Capstone Project](https://github.com/rkanderson/sumatra-surf-conservation). Within SCRUM, I focused on the **tradeoff between upfront planning and taking immediate action**, aiming to quantify how plan usefulness affects project efficiency.

### Modeling Plan Usefulness

I hypothesized that the **usefulness of a plan decays over time** and modeled it as an exponential decay function:

$$ u_{t+1} = r u_t $$

where $u$ is the usefulness of the plan and $r$ is a decay rate between 0 and 1. This usefulness factor influences task duration:

$$ D_t = B(1 - p u_t) $$

* $D$ = task duration at period $t$
* $B$ = base duration (without a plan)
* $p$ = planning effectiveness (proportion of task improved by a perfect plan)

> Note: $t$ resets to “time since last plan” so that the plan can be refreshed to maximum usefulness.

### Modeling Planning Overhead

I also modeled **planning overhead** as:

$$ L = c \sigma + k $$

* $L$ = total planning time
* $\sigma$ = scope of the plan
* $c$ and $k$ = constants representing variable and fixed costs

In traditional projects, the plan is created upfront with a large scope, and its usefulness decays continuously. SCRUM introduces **more frequent planning with shorter scopes**, refreshing usefulness but requiring time for repeated planning (like sprint review meetings).

---

## Shiny App

I built a **Shiny app** that allows users to tweak variables and simulate project outcomes, visualizing total person-hours over the weeks:

[View the app](https://rkanderson.shinyapps.io/scrum_project_planning_tradeoff_model/)

---

## Results

Results are discussed further in my [slide deck](https://docs.google.com/presentation/d/1El0y97HjurRNVl77n8ZyXXEB2do57aIJoinLDRqrfOg/edit?slide=id.g31a9226fd74_0_571#slide=id.g31a9226fd74_0_571), with stochastic modeling based on Bren group projects (Slide 5). Key observations include:

* With no additional information, **max-duration planning often saves the most time**, contrary to expectations.
* No planning scope consistently outperformed others; results are sensitive to team and project factors.
* For smaller scopes, distributions appear **bimodal**, suggesting interesting dynamics that affect optimal planning scope.

Interestingly, in many simulations, plans decayed to near zero usefulness, implying that some projects might have been better off with **no plan at all**.

### Future Hypotheses

* **Non-linear planning costs**: Time required may scale **exponentially** with plan scope due to interactions between project components, rather than linearly as assumed in the current model. This could influence optimal planning strategies.

---

## Exploration Documents

These documents show the modeling process and analysis:

* [ex1-develop-basic-model](explorations/ex1-develop-basic-model.html)
* [ex3.1-tests-of-various-scopes-under-single-set-of-paramms](explorations/ex3.1-tests-of-various-scopes-under-single-set-of-paramms.html)
* [ex4-analyzing-the-param-combo-run-data](explorations/ex4-analyzing-the-param-combo-run-data.html)

