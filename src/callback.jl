"Abstract type of callback functions used in training"
abstract AbstractCallback

"Abstract type of callbacks to be called every mini-batch"
abstract AbstractIterationCallback

"Abstract type of callbacks to be called every epoch"
abstract AbstractEpochCallback

type CallbackParams
  batch_size :: Int
  curr_epoch :: Int
  curr_iter  :: Int
end
CallbackParams(batch_size::Int) = CallbackParams(batch_size, 0, 0)

type IterationCallback
  frequency :: Int
  call_on_0 :: Bool
  callback  :: Function
end

function every_n_iter(callback :: Function, n :: Int, call_on_0 :: Bool = false)
  IterationCallback(n, call_on_0, callback)
end
function Base.call(cb :: IterationCallback, param :: CallbackParams)
  if param.curr_iter == 0
    if cb.call_on_0
      cb.callback(param)
    end
  elseif param.curr_iter % cb.frequency == 0
    cb.callback(param)
  end
end

function speedometer(frequency::Int=50)
  cl_tic = 0
  every_n_iter(frequency, true) do params :: CallbackParams
    if param.curr_iter == 0
      # reset counter
      cl_tic = time()
    else
      speed = frequency * params.batch_size / (time() - cl_tic)
      info("Speed: {1:>6.2} samples/sec", speed)
      cl_tic = time()
    end
  end
end
