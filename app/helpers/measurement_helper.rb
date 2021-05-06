module MeasurementHelper

  def counter_measurement(number)
    number_to_human(number, units: { thousand: 'T', million: 'M', billion: 'B', trillion: 'T', quadrillion: 'Q' })
  end
end
