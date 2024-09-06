{smcl}
{* *! version 0.1, 18 July 2024}{...}
{cmd:help for rwrlite}{right:Geoffrey T. Wodtke}
{hline}

{title:Title}

{p2colset 5 18 18 2}{...}
{p2col : {cmd:rwrlite} {hline 2}}causal mediation analysis using regression-with-residuals; 
this command a lite version of {helpb rwrmed}{p_end}
{p2colreset}{...}


{title:Syntax}


{p 8 14 2}
{cmd:rwrmed} {depvar} [{help indepvars:lvars}] {ifin} [{it:{help weight:pweight}}] {cmd:,}
{cmdab:dvar(}{it:{help varname:varname}}{cmd:)}
{cmdab:mvar(}{it:{help varname:varname}}{cmd:)}
{opt d(#)}
{opt dstar(#)}
{opt m(#)}
[{cmdab:cvars(}{it:{help varlist:varlist}}{cmd:)}
{cmdab:cat(}{it:{help varlist:varlist}}{cmd:)}
{opt nointer:action}
{opt cxd}
{opt cxm}
{opt lxm}
{opt reps(integer)} 
{cmdab:strata(}{it:{help varname:varname}}{cmd:)}
{cmdab:cluster(}{it:{help varname:varname}}{cmd:)}
{opt level(cilevel)} 
{opt seed(passthru)}
{opt detail}
]

{pstd}
{it:lvars} are post-treatment covariates (i.e., potential exposure-induced confounders)

{synoptset 32 tabbed}{...}
{synopthdr}
{synoptline}

{p2coldent:* {opt dvar}{cmd:(}{it:varname}{cmd:)}}specify the treatment (exposure) variable {p_end}

{p2coldent:* {opt mvar}{cmd:(}{it:varname}{cmd:)}}specify the mediator variable  {p_end}

{p2coldent:* {opt d}{cmd:(}{it:#}{cmd:)}}set the reference level of treatment  {p_end}

{p2coldent:* {opt dstar}{cmd:(}{it:#}{cmd:)}}set the alternative level of treatment  {p_end}

{p2coldent:* {opt m}{cmd:(}{it:#}{cmd:)}}set the level of the mediator at which the controlled direct effect 
is evaluated. If there is no treatment-mediator interaction, then the controlled direct effect
is the same at all levels of the mediator and thus an arbitary value can be chosen {p_end}

{synopt:{opt cvars}{cmd:(}{it:varlist}{cmd:)}}specify the baseline covariates to be included in the analysis {p_end}

{synopt:{opt cat}{cmd:(}{it:varlist}{cmd:)}}specify which of the {cmd: cvars} and {cmd: lvars} should be handled as categorical variables  {p_end}

{synopt:{opt nointer:action}}specify that a treatment-mediator interaction should not be included in the outcome model  {p_end}

{synopt:{opt cxd}}specify that treatment-covariate interactions should be included in the mediator and outcome models  {p_end}

{synopt:{opt cxm}}specify that mediator-covariate interactions should be included in the outcome model  {p_end}

{synopt:{opt lxm}}specify that mediator-posttreatment interactions should be included in the outcome model  {p_end}

{synopt:{opt reps(integer 200)}}specify the number of bootstrap replications (the default is 200).

{synopt:{opt strata(varname)}}specify a variable that identifies resampling strata for the bootstrap.

{synopt:{opt cluster(varname)}}specify a variable that identifies resampling clusters for the bootstrap.

{synopt:{opt level(cilevel)}}specify the confidence level for constructing bootstrap confidence intervals (the default is 95%).

{synopt:{opt seed(passthru)}}specify the seed for bootstrap resampling.{p_end}

{synopt:{opt detail}}print the fitted models for the mediator and outcome in addition to the effect estimates.{p_end}

{synoptline}
{p2colreset}{...}
{p 4 6 2}
* required option.
{p_end}
{marker weight}{...}
{p 4 6 2}{opt pweight}s are allowed; see {help weight}.{p_end}
{p 4 6 2}


{title:Description}

{pstd}{cmd:rwrlite} is a lite version of {helpb rwrmed}. It drops some specialized functionality from {helpb rwrmed}
for the sake of simplicity, always reports percentile bootstrap intervals, and relabels certain estimands. Otherwise, they are 
essentially the same, both performing causal mediation analysis using regression-with-residuals. Using {helpb gsem}, 
two models are estimated: a model for the mediator conditional on treatment and the baseline covariates (if specified) after centering 
them around their sample means, and a model for the outcome conditional on treatment, the mediator, the baseline covariates 
(if specified) after centering them around their sample means, and the post-treatment covariates (if specified) after 
centering them around their estimated conditional means given all prior variables. Thus {cmd:rwrlite} allows for the presence of 
treatment-induced confounders, which are post-treatment covariates that confound the mediator-outcome relationship.

{pstd}{cmd:rwrlite} uses {opt reg:ress} for the outcome and for the mediator, and either {opt reg:ress} or {opt logit} to residualize the post-treatment covariates.

{pstd}{cmd:rwrlite} provides estimates of the controlled direct effect and then the interventional direct effect,
the interventional indirect effect, and the overall effect, when a set of measured post-treatment covariates are included in {opt lvars}. 
These estimands are also known as randomized intervention analogues to the natural direct effect, the natural indirect effect, 
and the total effect. When post-treatment covariates are not included in {opt lvars}, the command instead 
provides estimates of the conventional natural direct and indirect effects and the conventional total effect. 

{title:Assumptions}

{pstd}Let C be the measured pre-treatment covariates included in {opt cvars(varlist)}, and let L be the measured post-treatment covariates
included in {opt lvars(varlist)}. Obtaining consistent estimates of the controlled direct effect requires two main assumptions: {p_end}

{phang2}(1) There are no unmeasured treatment-outcome confounders given C {p_end}
{phang2}(2) There are no unmeasured mediator-outcome confounders given C and L {p_end}

{pstd}Obtaining consistent estimates of the interventional direct and indirect effects requires assumptions (1) 
and (2) and then an additional assumption: {p_end}

{phang2}(3) There are no unmeasured treatment-mediator confounders given C {p_end}

{pstd}Note that assumptions (1) and (3) are satisified by random assignment of the treatment variable. See references for further details. {p_end}


{title:Options}

{p 4 8 2}
{cmd:dvar(}{it:varname}{cmd:)} specifies the treatment (exposure) variable; {cmd:dvar() is required}. 

{p 4 8 2}
{cmd:mvar(}{it:varname}{cmd:)} specifies the mediator variable; {cmd:mvar() is required}.

{p 4 8 2}
{cmd:d(}{it:#}{cmd:)} sets the reference level of treatment; {cmd:d() is required}.

{p 4 8 2}
{cmd:dstar(}{it:#}{cmd:)} sets the alternative level of treatment. Together, (d - dstar) defines
the treatment contrast of interest; {cmd:dstar() is required}.

{p 4 8 2}
{cmd:m(}{it:#}{cmd:)} sets the level of the mediator at which the controlled direct effect 
is evaluated. If there is no treatment-mediator interaction, then the controlled direct effect
is the same at all levels of the mediator and thus an arbitrary value can be chosen; {cmd:m() is required}.

{p 4 8 2}
{opt cvars}{cmd:(}{it:varlist}{cmd:)} specifies the pre-treatment covariates to be included in the analysis. 

{p 4 8 2}
{opt cat}{cmd:(}{it:varlist}{cmd:)} specifies which of the {cmd: cvars} and {cmd: lvars} should be handled as categorical variables.
For multi-categorical variables, {cmd:rwrlite} generates dummy variables for each level and then residualizes them individually. A warning
message will be issued if the logit model produces perfect predictions, resulting in dropped observations. The program will terminate
if the logit model cannot converge. In both of these cases (dropped observations or model non-convergence), the user should consider either
collapsing the multi-categorical variable into fewer categories, or specify it as a continuous variable (by not adding it to {cmd:cat()}).

{p 4 8 2}
{opt nointeraction} specifies that a treatment-mediator interaction should not be included in the outcome model. When not specified, {cmd:rwrmed}
will generate a treatment-mediator interaction term.

{p 4 8 2}
{opt cxa} specifies that treatment-covariate interactions be included in the mediator and outcome models.

{p 4 8 2}
{opt cxm} specifies that mediator-covariate interactions be included in the outcome model.

{p 4 8 2}
{opt lxm} specifies that mediator-posttreatment interactions be included in the outcome model.

{p 4 8 2}
{opt reps(integer)} specifies the number of replications for bootstrap resampling (the default is 200).

{p 4 8 2}
{opt strata(varname)} specifies a variable that identifies resampling strata. If this option is specified, 
then bootstrap samples are taken independently within each stratum.

{p 4 8 2}
{opt cluster(varname)} specifies a variable that identifies resampling clusters. If this option is specified,
then the sample drawn during each replication is a bootstrap sample of clusters.

{p 4 8 2}
{opt level(cilevel)} specifies the confidence level for constructing bootstrap confidence intervals. If this 
option is omitted, then the default level of 95% is used.

{p 4 8 2}
{opt seed(passthru)} specifies the seed for bootstrap resampling. If this option is omitted, then a random 
seed is used and the results cannot be replicated. 

{p 4 8 2}
{opt detail} prints the fitted models for the mediator and outcome in addition to the effect estimates.{p_end}

{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. use nlsy.dta} {p_end}

 
{pstd} no interaction between treatment and mediator, percentile bootstrap CIs with default settings: {p_end}
 
{phang2}{cmd:. rwrlite std_cesd_age40 ever_unemp_age3539, dvar(att22) mvar(log_faminc_adj_age3539) cvars(female black hispan paredu parprof parinc_prank famsize afqt3)	d(1) dstar(0) nointer reps(200)} {p_end}

{pstd} treatment-mediator interaction, percentile bootstrap CIs with default settings: {p_end}
 
{phang2}{cmd:. rwrlite std_cesd_age40 ever_unemp_age3539, dvar(att22) mvar(log_faminc_adj_age3539) cvars(female black hispan paredu parprof parinc_prank famsize afqt3)	d(1) dstar(0) reps(200)} {p_end}

{pstd} treatment-mediator interaction, all two-way interactions, percentile bootstrap CIs with default settings: {p_end}
 
{phang2}{cmd:. rwrlite std_cesd_age40 ever_unemp_age3539, dvar(att22) mvar(log_faminc_adj_age3539) cvars(female black hispan paredu parprof parinc_prank famsize afqt3)	d(1) dstar(0) cxd cxm lxm reps(200)} {p_end}



{title:Saved results}

{pstd}{cmd:rwrlite} saves the following results in {cmd:e()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Matrices}{p_end}
{synopt:{cmd:e(b)}}matrix containing the effect estimates{p_end}

{title:Author}

{pstd}Geoffrey T. Wodtke {break}
Department of Sociology{break}
University of Chicago{p_end}

{phang}Email: wodtke@uchicago.edu


{title:References}

{pstd}Wodtke GT and Zhou X. Causal Mediation Analysis. In preparation. {p_end}

{title:Also see}

{psee}
Help: {helpb rwrmed} (if installed), {helpb gsem}, {helpb bootstrap}
{p_end}


{title:Acknowledgments}

{pstd}I thank Ariel Linden for his work developing {cmd:rwrmed}, on which {cmd:rwrlite} is based.{p_end}
