class DeleteMuxStreamJob < ApplicationJob
  
  def run(stream_id)
    stream = Stream.find_by(id: stream_id)
    return unless stream
    
    live_api = MuxRuby::LiveStreamsApi.new
    live_api.delete_live_stream(stream.mux_stream_id)
  end
end
