beta_sample_for = (mean, variance) ->
  alpha = ( (1 - mean) / variance - 1 / mean ) * mean * mean
  beta = alpha * (1/mean - 1)
  jStat.beta.sample(alpha, beta)
