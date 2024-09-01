# rwrlite: Causal Mediation Analysis Using Regression-With-Residuals (Lite Version)

`rwrlite` is a streamlined version of the `rwrmed` module for performing causal mediation analysis using regression-with-residuals. It simplifies and omit some functionalities for ease of use and focuses on essential computations.

## Syntax

```stata
rwrlite depvar lvars, dvar(varname) mvar(varname) d(#) dstar(#) m(#) [options]
```

### Required Arguments

- `depvar`: Specifies the outcome variable.
- `lvars`: Specifies the exposure-induced confounders.
- `dvar(varname)`: Specifies the treatment (exposure) variable.
- `mvar(varname)`: Specifies the mediator variable.
- `d(#)`: Reference level of treatment.
- `dstar(#)`: Alternative level of treatment, defining the treatment contrast of interest.
- `m(#)`: Level of the mediator at which the controlled direct effect is evaluated.

### Options

- `cvars(varlist)`: Baseline covariates to include in the analysis.
- `cat(varlist)`: Specifies which variables should be handled as categorical.
- `nointer`: Excludes treatment-mediator interaction from the outcome model.
- `cxa`: Includes treatment-covariate interactions in all models.
- `cxm`: Includes mediator-covariate interactions in the outcome model.
- `lxm`: Includes mediator-posttreatment interactions in the outcome model.
- `reps(integer)`: Number of bootstrap replications (default is 200).
- `strata(varname)`: Identifies resampling strata.
- `cluster(varname)`: Identifies resampling clusters.
- `level(cilevel)`: Confidence level for bootstrap confidence intervals (default is 95%).
- `seed(passthru)`: Seed for bootstrap resampling.
- `detail`: Prints the fitted models in addition to the effect estimates.

## Description

`rwrlite` performs causal mediation analysis by estimating two models:
1. A model for the mediator conditional on treatment and baseline covariates, centered around their sample means.
2. A model for the outcome conditional on treatment, the mediator, the baseline covariates after centering them around their sample means, and any exposure-induced covariates after residualizing them with respect to the treatment and baseline covariates.

These models allow for the estimation of controlled direct effects, interventional direct effects, interventional indirect effects, and the overall effect. `rwrlite` accommodates treatment-induced confounders.

## Examples

```stata
// Load data
use nlsy.dta

// Default settings with no interaction between treatment and mediator
rwrlite std_cesd_age40 ever_unemp_age3539, dvar(att22) mvar(log_faminc_adj_age3539) cvars(female black hispan paredu parprof parinc_prank famsize afqt3) d(1) dstar(0) nointer reps(200)

// Including treatment-mediator interaction
rwrlite std_cesd_age40 ever_unemp_age3539, dvar(att22) mvar(log_faminc_adj_age3539) cvars(female black hispan paredu parprof parinc_prank famsize afqt3) d(1) dstar(0) reps(200)

// Including all two-way interactions
rwrlite std_cesd_age40 ever_unemp_age3539, dvar(att22) mvar(log_faminc_adj_age3539) cvars(female black hispan paredu parprof parinc_prank famsize afqt3) d(1) dstar(0) cxd cxm lxm reps(200)
```

## Saved Results

`rwrlite` saves the following results in `e()`:

- **Matrices**:
  - `e(b)`: Matrix containing the effect estimates.

## Author

Geoffrey T. Wodtke  
Department of Sociology  
University of Chicago

Email: [wodtke@uchicago.edu](mailto:wodtke@uchicago.edu)

## References

- Wodtke GT and Zhou X. Causal Mediation Analysis. In preparation.

## Also See

- [rwrmed](#) if installed
- [gsem](#)
- [bootstrap](#)

## Acknowledgments

Special thanks to Ariel Linden for developing `rwrmed`, upon which `rwrlite` is based.
