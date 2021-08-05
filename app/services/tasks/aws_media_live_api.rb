module Tasks
  class AwsMediaLiveApi
    @aws_client = Aws::MediaLive::Client.new(
      region: ENV['AWS_REGION'],
      access_key_id: ENV['AWS_MEDIA_PACKAGE_ACCESS_KEY_ID'],
      secret_access_key: ENV['AWS_MEDIA_PACKAGE_SECRET_ACCESS_KEY']
    )
    
    # Security Group methods
    def self.delete_input_security_group(input_security_group_id)
      @aws_client.delete_input_security_group({
        input_security_group_id: input_security_group_id
      })
    end
    
    def self.create_input_security_group()
      begin
        response = @aws_client.create_input_security_group({
          whitelist_rules: [
            {
              cidr: '0.0.0.0/0',
            },
          ]
        })
        response[0]
      rescue
        nil
      end
    end
    
    # Input methods
    def self.delete_input(stream_access_token)
      
    end
    
    def self.create_input(stream_access_token, input_security_group)
      return if input_security_group.blank?
      
      begin
        response = @aws_client.create_input({
          destinations: [
            {
              stream_name: "#{stream_access_token}/stream",
            },
          ],
          input_security_groups: [input_security_group.id],
          name: stream_access_token,
          type: "RTMP_PUSH",
        })
        response[0]
      rescue
        nil
      end
    end
    
    # Chanel methods
    def self.channel_status(stream_access_token)
      
    end
    
    def self.create_channel(stream_access_token, input_to_attach)
      media_store_endpoint = Tasks::AwsMediaStoreApi.get_container&.endpoint
      return if media_store_endpoint.blank?
      
      begin
        mediastore_destination_url = media_store_endpoint.gsub('https','mediastoressl')+"/#{stream_access_token}/index"
        response = @aws_client.create_channel({
          channel_class: "SINGLE_PIPELINE",
          destinations: [
            {
              id: "destination-#{stream_access_token}",
              settings: [
                {
                  url: mediastore_destination_url,
                },
              ],
            },
          ],
          name: "screade-ml-#{stream_access_token}",
          input_attachments: [
            {
              input_id: input_to_attach.id,
              input_settings: {
                audio_selectors: [],
                caption_selectors: []
              }
            }
          ],
          encoder_settings: {
            audio_descriptions: [
              {
                codec_settings: {
                  aac_settings: {
                    bitrate: 96000,
                    coding_mode: "CODING_MODE_2_0", # accepts AD_RECEIVER_MIX, CODING_MODE_1_0, CODING_MODE_1_1, CODING_MODE_2_0, CODING_MODE_5_1
                    input_type: "NORMAL", # accepts BROADCASTER_MIXED_AD, NORMAL
                    profile: "LC", # accepts HEV1, HEV2, LC
                    rate_control_mode: "CBR", # accepts CBR, VBR
                    raw_format: "NONE", # accepts LATM_LOAS, NONE
                    sample_rate: 48000,
                    spec: "MPEG4", # accepts MPEG2, MPEG4
                  }
                },
                audio_type_control: "FOLLOW_INPUT", # accepts FOLLOW_INPUT, USE_CONFIGURED
                audio_selector_name: "default", # required
                language_code_control: "FOLLOW_INPUT", # accepts FOLLOW_INPUT, USE_CONFIGURED
                name: "audio_j8tr8"
              },
              {
                codec_settings: {
                  aac_settings: {
                    bitrate: 96000,
                    coding_mode: "CODING_MODE_2_0", # accepts AD_RECEIVER_MIX, CODING_MODE_1_0, CODING_MODE_1_1, CODING_MODE_2_0, CODING_MODE_5_1
                    input_type: "NORMAL", # accepts BROADCASTER_MIXED_AD, NORMAL
                    profile: "LC", # accepts HEV1, HEV2, LC
                    rate_control_mode: "CBR", # accepts CBR, VBR
                    raw_format: "NONE", # accepts LATM_LOAS, NONE
                    sample_rate: 48000,
                    spec: "MPEG4", # accepts MPEG2, MPEG4
                  }
                },
                audio_type_control: "FOLLOW_INPUT", # accepts FOLLOW_INPUT, USE_CONFIGURED
                audio_selector_name: "default", # required
                language_code_control: "FOLLOW_INPUT", # accepts FOLLOW_INPUT, USE_CONFIGURED
                name: "audio_6ht2vm"
              },
              {
                codec_settings: {
                  aac_settings: {
                    bitrate: 96000,
                    coding_mode: "CODING_MODE_2_0", # accepts AD_RECEIVER_MIX, CODING_MODE_1_0, CODING_MODE_1_1, CODING_MODE_2_0, CODING_MODE_5_1
                    input_type: "NORMAL", # accepts BROADCASTER_MIXED_AD, NORMAL
                    profile: "LC", # accepts HEV1, HEV2, LC
                    rate_control_mode: "CBR", # accepts CBR, VBR
                    raw_format: "NONE", # accepts LATM_LOAS, NONE
                    sample_rate: 48000,
                    spec: "MPEG4", # accepts MPEG2, MPEG4
                  }
                },
                audio_type_control: "FOLLOW_INPUT", # accepts FOLLOW_INPUT, USE_CONFIGURED
                audio_selector_name: "default", # required
                language_code_control: "FOLLOW_INPUT", # accepts FOLLOW_INPUT, USE_CONFIGURED
                name: "audio_s90hue"
              },
              {
                codec_settings: {
                  aac_settings: {
                    bitrate: 96000,
                    coding_mode: "CODING_MODE_2_0", # accepts AD_RECEIVER_MIX, CODING_MODE_1_0, CODING_MODE_1_1, CODING_MODE_2_0, CODING_MODE_5_1
                    input_type: "NORMAL", # accepts BROADCASTER_MIXED_AD, NORMAL
                    profile: "LC", # accepts HEV1, HEV2, LC
                    rate_control_mode: "CBR", # accepts CBR, VBR
                    raw_format: "NONE", # accepts LATM_LOAS, NONE
                    sample_rate: 48000,
                    spec: "MPEG4", # accepts MPEG2, MPEG4
                  }
                },
                audio_type_control: "FOLLOW_INPUT", # accepts FOLLOW_INPUT, USE_CONFIGURED
                audio_selector_name: "default", # required
                language_code_control: "FOLLOW_INPUT", # accepts FOLLOW_INPUT, USE_CONFIGURED
                name: "audio_i3rm19"
              }
            ],
            avail_configuration: {
              avail_settings: {
                scte_35_splice_insert: {
                  no_regional_blackout_flag: "FOLLOW", # accepts FOLLOW, IGNORE
                  web_delivery_allowed_flag: "FOLLOW", # accepts FOLLOW, IGNORE
                }
              }
            },
            caption_descriptions: [],
            output_groups: [
              {
                name: "HLS SD",
                output_group_settings: {
                  hls_group_settings: {
                    ad_markers: ["ELEMENTAL_SCTE35"],
                    caption_language_setting: "OMIT",
                    caption_language_mappings: [],
                    input_loss_action: "EMIT_OUTPUT",
                    manifest_compression: "NONE",
                    destination: {
                      destination_ref_id: "destination-#{stream_access_token}"
                    },
                    iv_in_manifest: "INCLUDE",
                    iv_source: "FOLLOWS_SEGMENT_NUMBER",
                    client_cache: "ENABLED",
                    ts_file_mode: "SEGMENTED_FILES",
                    manifest_duration_format: "FLOATING_POINT",
                    segmentation_mode: "USE_SEGMENT_DURATION",
                    redundant_manifest: "DISABLED",
                    output_selection: "MANIFESTS_AND_SEGMENTS",
                    stream_inf_resolution: "INCLUDE",
                    i_frame_only_playlists: "DISABLED",
                    index_n_segments: 10,
                    program_date_time: "EXCLUDE",
                    program_date_time_period: 600,
                    keep_segments: 21,
                    segment_length: 4,
                    timed_metadata_id_3_frame: "PRIV",
                    timed_metadata_id_3_period: 10,
                    hls_id_3_segment_tagging: "DISABLED",
                    codec_specification: "RFC_4281",
                    directory_structure: "SINGLE_DIRECTORY",
                    segments_per_subdirectory: 10000,
                    mode: "LIVE"
                  }
                },
                outputs: [
                  {
                    output_settings: {
                      hls_output_settings: {
                        name_modifier: "_512x288",
                        segment_modifier: "_$t$_",
                        hls_settings: {
                          standard_hls_settings: {
                            m3u_8_settings: {
                              audio_frames_per_pes: 4,
                              audio_pids: "492-498",
                              nielsen_id_3_behavior: "NO_PASSTHROUGH", # accepts NO_PASSTHROUGH, PASSTHROUGH
                              pcr_control: "PCR_EVERY_PES_PACKET", # accepts CONFIGURED_PCR_PERIOD, PCR_EVERY_PES_PACKET
                              pmt_pid: "480",
                              program_num: 1,
                              scte_35_behavior: "PASSTHROUGH", # accepts NO_PASSTHROUGH, PASSTHROUGH
                              scte_35_pid: "500",
                              timed_metadata_behavior: "NO_PASSTHROUGH", # accepts NO_PASSTHROUGH, PASSTHROUGH
                              timed_metadata_pid: "502",
                              video_pid: "481",
                            },
                            audio_rendition_sets: "program_audio"
                          }
                        },
                        h265_packaging_type: "HVC1"
                      }
                    },
                    output_name: "_512x288",
                    video_description_name: "_512x288",
                    audio_description_names: ["audio_j8tr8"],
                    caption_description_names: []
                  },
                  {
                    output_settings: {
                      hls_output_settings: {
                        name_modifier: "_640x360",
                        segment_modifier: "_$t$_",
                        hls_settings: {
                          standard_hls_settings: {
                            m3u_8_settings: {
                              audio_frames_per_pes: 4,
                              audio_pids: "492-498",
                              nielsen_id_3_behavior: "NO_PASSTHROUGH", # accepts NO_PASSTHROUGH, PASSTHROUGH
                              pcr_control: "PCR_EVERY_PES_PACKET", # accepts CONFIGURED_PCR_PERIOD, PCR_EVERY_PES_PACKET
                              pmt_pid: "480",
                              program_num: 1,
                              scte_35_behavior: "PASSTHROUGH", # accepts NO_PASSTHROUGH, PASSTHROUGH
                              scte_35_pid: "500",
                              timed_metadata_behavior: "NO_PASSTHROUGH", # accepts NO_PASSTHROUGH, PASSTHROUGH
                              timed_metadata_pid: "502",
                              video_pid: "481",
                            },
                            audio_rendition_sets: "program_audio"
                          }
                        },
                        h265_packaging_type: "HVC1"
                      }
                    },
                    output_name: "_640x360",
                    video_description_name: "_640x360",
                    audio_description_names: ["audio_6ht2vm"],
                    caption_description_names: []
                  },
                  {
                    output_settings: {
                      hls_output_settings: {
                        name_modifier: "_768x432",
                        segment_modifier: "_$t$_",
                        hls_settings: {
                          standard_hls_settings: {
                            m3u_8_settings: {
                              audio_frames_per_pes: 4,
                              audio_pids: "492-498",
                              nielsen_id_3_behavior: "NO_PASSTHROUGH", # accepts NO_PASSTHROUGH, PASSTHROUGH
                              pcr_control: "PCR_EVERY_PES_PACKET", # accepts CONFIGURED_PCR_PERIOD, PCR_EVERY_PES_PACKET
                              pmt_pid: "480",
                              program_num: 1,
                              scte_35_behavior: "PASSTHROUGH", # accepts NO_PASSTHROUGH, PASSTHROUGH
                              scte_35_pid: "500",
                              timed_metadata_behavior: "NO_PASSTHROUGH", # accepts NO_PASSTHROUGH, PASSTHROUGH
                              timed_metadata_pid: "502",
                              video_pid: "481",
                            },
                            audio_rendition_sets: "program_audio"
                          }
                        },
                        h265_packaging_type: "HVC1"
                      }
                    },
                    output_name: "_768x432",
                    video_description_name: "_768x432",
                    audio_description_names: ["audio_s90hue"],
                    caption_description_names: []
                  },
                  {
                    output_settings: {
                      hls_output_settings: {
                        name_modifier: "_960x540",
                        segment_modifier: "_$t$_",
                        hls_settings: {
                          standard_hls_settings: {
                            m3u_8_settings: {
                              audio_frames_per_pes: 4,
                              audio_pids: "492-498",
                              nielsen_id_3_behavior: "NO_PASSTHROUGH", # accepts NO_PASSTHROUGH, PASSTHROUGH
                              pcr_control: "PCR_EVERY_PES_PACKET", # accepts CONFIGURED_PCR_PERIOD, PCR_EVERY_PES_PACKET
                              pmt_pid: "480",
                              program_num: 1,
                              scte_35_behavior: "PASSTHROUGH", # accepts NO_PASSTHROUGH, PASSTHROUGH
                              scte_35_pid: "500",
                              timed_metadata_behavior: "NO_PASSTHROUGH", # accepts NO_PASSTHROUGH, PASSTHROUGH
                              timed_metadata_pid: "502",
                              video_pid: "481",
                            },
                            audio_rendition_sets: "program_audio"
                          }
                        },
                        h265_packaging_type: "HVC1"
                      }
                    },
                    output_name: "_960x540",
                    video_description_name: "_960x540",
                    audio_description_names: ["audio_i3rm19"],
                    caption_description_names: []
                  }
                ]
              }
            ],
            timecode_config: {
              source: "EMBEDDED"
            },
            video_descriptions: [
              {
                codec_settings: {
                  h264_settings: {
                    adaptive_quantization: "HIGH", # accepts AUTO, HIGH, HIGHER, LOW, MAX, MEDIUM, OFF
                    afd_signaling: "NONE", # accepts AUTO, FIXED, NONE
                    bitrate: 400000,
                    buf_fill_pct: 90,
                    buf_size: 800000,
                    color_metadata: "INSERT", # accepts IGNORE, INSERT
                    entropy_encoding: "CAVLC", # accepts CABAC, CAVLC
                    flicker_aq: "ENABLED", # accepts DISABLED, ENABLED
                    framerate_control: "SPECIFIED", # accepts INITIALIZE_FROM_SOURCE, SPECIFIED
                    framerate_denominator: 1,
                    framerate_numerator: 15,
                    gop_b_reference: "ENABLED", # accepts DISABLED, ENABLED
                    gop_closed_cadence: 1,
                    gop_num_b_frames: 0,
                    gop_size: 2,
                    gop_size_units: "SECONDS", # accepts FRAMES, SECONDS
                    level: "H264_LEVEL_AUTO", # accepts H264_LEVEL_1, H264_LEVEL_1_1, H264_LEVEL_1_2, H264_LEVEL_1_3, H264_LEVEL_2, H264_LEVEL_2_1, H264_LEVEL_2_2, H264_LEVEL_3, H264_LEVEL_3_1, H264_LEVEL_3_2, H264_LEVEL_4, H264_LEVEL_4_1, H264_LEVEL_4_2, H264_LEVEL_5, H264_LEVEL_5_1, H264_LEVEL_5_2, H264_LEVEL_AUTO
                    look_ahead_rate_control: "HIGH", # accepts HIGH, LOW, MEDIUM
                    max_bitrate: 400000,
                    num_ref_frames: 5,
                    par_control: "INITIALIZE_FROM_SOURCE", # accepts INITIALIZE_FROM_SOURCE, SPECIFIED
                    profile: "BASELINE", # accepts BASELINE, HIGH, HIGH_10BIT, HIGH_422, HIGH_422_10BIT, MAIN
                    qvbr_quality_level: 6,
                    rate_control_mode: "QVBR", # accepts CBR, MULTIPLEX, QVBR, VBR
                    scan_type: "PROGRESSIVE", # accepts INTERLACED, PROGRESSIVE
                    scene_change_detect: "ENABLED", # accepts DISABLED, ENABLED
                    spatial_aq: "ENABLED", # accepts DISABLED, ENABLED
                    subgop_length: "DYNAMIC", # accepts DYNAMIC, FIXED
                    syntax: "DEFAULT", # accepts DEFAULT, RP2027
                    temporal_aq: "ENABLED", # accepts DISABLED, ENABLED
                    timecode_insertion: "DISABLED", # accepts DISABLED, PIC_TIMING_SEI
                  }
                },
                height: 288,
                name: "_512x288",
                respond_to_afd: "NONE",
                sharpness: 100,
                scaling_behavior: "DEFAULT",
                width: 512
              },
              {
                codec_settings: {
                  h264_settings: {
                    adaptive_quantization: "HIGH", # accepts AUTO, HIGH, HIGHER, LOW, MAX, MEDIUM, OFF
                    afd_signaling: "NONE", # accepts AUTO, FIXED, NONE
                    bitrate: 800000,
                    buf_fill_pct: 90,
                    buf_size: 1600000,
                    color_metadata: "INSERT", # accepts IGNORE, INSERT
                    entropy_encoding: "CAVLC", # accepts CABAC, CAVLC
                    flicker_aq: "ENABLED", # accepts DISABLED, ENABLED
                    framerate_control: "SPECIFIED", # accepts INITIALIZE_FROM_SOURCE, SPECIFIED
                    framerate_denominator: 1,
                    framerate_numerator: 30,
                    gop_b_reference: "ENABLED", # accepts DISABLED, ENABLED
                    gop_closed_cadence: 1,
                    gop_num_b_frames: 0,
                    gop_size: 2,
                    gop_size_units: "SECONDS", # accepts FRAMES, SECONDS
                    level: "H264_LEVEL_AUTO", # accepts H264_LEVEL_1, H264_LEVEL_1_1, H264_LEVEL_1_2, H264_LEVEL_1_3, H264_LEVEL_2, H264_LEVEL_2_1, H264_LEVEL_2_2, H264_LEVEL_3, H264_LEVEL_3_1, H264_LEVEL_3_2, H264_LEVEL_4, H264_LEVEL_4_1, H264_LEVEL_4_2, H264_LEVEL_5, H264_LEVEL_5_1, H264_LEVEL_5_2, H264_LEVEL_AUTO
                    look_ahead_rate_control: "HIGH", # accepts HIGH, LOW, MEDIUM
                    max_bitrate: 800000,
                    num_ref_frames: 5,
                    par_control: "INITIALIZE_FROM_SOURCE", # accepts INITIALIZE_FROM_SOURCE, SPECIFIED
                    profile: "BASELINE", # accepts BASELINE, HIGH, HIGH_10BIT, HIGH_422, HIGH_422_10BIT, MAIN
                    qvbr_quality_level: 7,
                    rate_control_mode: "QVBR", # accepts CBR, MULTIPLEX, QVBR, VBR
                    scan_type: "PROGRESSIVE", # accepts INTERLACED, PROGRESSIVE
                    scene_change_detect: "ENABLED", # accepts DISABLED, ENABLED
                    spatial_aq: "ENABLED", # accepts DISABLED, ENABLED
                    subgop_length: "DYNAMIC", # accepts DYNAMIC, FIXED
                    syntax: "DEFAULT", # accepts DEFAULT, RP2027
                    temporal_aq: "ENABLED", # accepts DISABLED, ENABLED
                    timecode_insertion: "DISABLED", # accepts DISABLED, PIC_TIMING_SEI
                  }
                },
                height: 360,
                name: "_640x360",
                respond_to_afd: "NONE",
                sharpness: 100,
                scaling_behavior: "DEFAULT",
                width: 640
              },
              {
                codec_settings: {
                  h264_settings: {
                    adaptive_quantization: "HIGH", # accepts AUTO, HIGH, HIGHER, LOW, MAX, MEDIUM, OFF
                    afd_signaling: "NONE", # accepts AUTO, FIXED, NONE
                    bitrate: 1200000,
                    buf_fill_pct: 90,
                    buf_size: 2400000,
                    color_metadata: "INSERT", # accepts IGNORE, INSERT
                    entropy_encoding: "CAVLC", # accepts CABAC, CAVLC
                    flicker_aq: "ENABLED", # accepts DISABLED, ENABLED
                    framerate_control: "SPECIFIED", # accepts INITIALIZE_FROM_SOURCE, SPECIFIED
                    framerate_denominator: 1,
                    framerate_numerator: 30,
                    gop_b_reference: "ENABLED", # accepts DISABLED, ENABLED
                    gop_closed_cadence: 1,
                    gop_num_b_frames: 0,
                    gop_size: 2,
                    gop_size_units: "SECONDS", # accepts FRAMES, SECONDS
                    level: "H264_LEVEL_AUTO", # accepts H264_LEVEL_1, H264_LEVEL_1_1, H264_LEVEL_1_2, H264_LEVEL_1_3, H264_LEVEL_2, H264_LEVEL_2_1, H264_LEVEL_2_2, H264_LEVEL_3, H264_LEVEL_3_1, H264_LEVEL_3_2, H264_LEVEL_4, H264_LEVEL_4_1, H264_LEVEL_4_2, H264_LEVEL_5, H264_LEVEL_5_1, H264_LEVEL_5_2, H264_LEVEL_AUTO
                    look_ahead_rate_control: "HIGH", # accepts HIGH, LOW, MEDIUM
                    max_bitrate: 1200000,
                    num_ref_frames: 5,
                    par_control: "INITIALIZE_FROM_SOURCE", # accepts INITIALIZE_FROM_SOURCE, SPECIFIED
                    profile: "BASELINE", # accepts BASELINE, HIGH, HIGH_10BIT, HIGH_422, HIGH_422_10BIT, MAIN
                    qvbr_quality_level: 7,
                    rate_control_mode: "QVBR", # accepts CBR, MULTIPLEX, QVBR, VBR
                    scan_type: "PROGRESSIVE", # accepts INTERLACED, PROGRESSIVE
                    scene_change_detect: "ENABLED", # accepts DISABLED, ENABLED
                    spatial_aq: "ENABLED", # accepts DISABLED, ENABLED
                    subgop_length: "DYNAMIC", # accepts DYNAMIC, FIXED
                    syntax: "DEFAULT", # accepts DEFAULT, RP2027
                    temporal_aq: "ENABLED", # accepts DISABLED, ENABLED
                    timecode_insertion: "DISABLED", # accepts DISABLED, PIC_TIMING_SEI
                  }
                },
                height: 432,
                name: "_768x432",
                respond_to_afd: "NONE",
                sharpness: 100,
                scaling_behavior: "DEFAULT",
                width: 768
              },
              {
                codec_settings: {
                  h264_settings: {
                    adaptive_quantization: "HIGH", # accepts AUTO, HIGH, HIGHER, LOW, MAX, MEDIUM, OFF
                    afd_signaling: "NONE", # accepts AUTO, FIXED, NONE
                    bitrate: 1800000,
                    buf_fill_pct: 90,
                    buf_size: 3600000,
                    color_metadata: "INSERT", # accepts IGNORE, INSERT
                    entropy_encoding: "CAVLC", # accepts CABAC, CAVLC
                    flicker_aq: "ENABLED", # accepts DISABLED, ENABLED
                    framerate_control: "SPECIFIED", # accepts INITIALIZE_FROM_SOURCE, SPECIFIED
                    framerate_denominator: 1,
                    framerate_numerator: 30,
                    gop_b_reference: "ENABLED", # accepts DISABLED, ENABLED
                    gop_closed_cadence: 1,
                    gop_num_b_frames: 0,
                    gop_size: 2,
                    gop_size_units: "SECONDS", # accepts FRAMES, SECONDS
                    level: "H264_LEVEL_AUTO", # accepts H264_LEVEL_1, H264_LEVEL_1_1, H264_LEVEL_1_2, H264_LEVEL_1_3, H264_LEVEL_2, H264_LEVEL_2_1, H264_LEVEL_2_2, H264_LEVEL_3, H264_LEVEL_3_1, H264_LEVEL_3_2, H264_LEVEL_4, H264_LEVEL_4_1, H264_LEVEL_4_2, H264_LEVEL_5, H264_LEVEL_5_1, H264_LEVEL_5_2, H264_LEVEL_AUTO
                    look_ahead_rate_control: "HIGH", # accepts HIGH, LOW, MEDIUM
                    max_bitrate: 1800000,
                    num_ref_frames: 5,
                    par_control: "INITIALIZE_FROM_SOURCE", # accepts INITIALIZE_FROM_SOURCE, SPECIFIED
                    profile: "BASELINE", # accepts BASELINE, HIGH, HIGH_10BIT, HIGH_422, HIGH_422_10BIT, MAIN
                    qvbr_quality_level: 7,
                    rate_control_mode: "QVBR", # accepts CBR, MULTIPLEX, QVBR, VBR
                    scan_type: "PROGRESSIVE", # accepts INTERLACED, PROGRESSIVE
                    scene_change_detect: "ENABLED", # accepts DISABLED, ENABLED
                    spatial_aq: "ENABLED", # accepts DISABLED, ENABLED
                    subgop_length: "DYNAMIC", # accepts DYNAMIC, FIXED
                    syntax: "DEFAULT", # accepts DEFAULT, RP2027
                    temporal_aq: "ENABLED", # accepts DISABLED, ENABLED
                    timecode_insertion: "DISABLED", # accepts DISABLED, PIC_TIMING_SEI
                  }
                },
                height: 540,
                name: "_960x540",
                respond_to_afd: "NONE",
                sharpness: 100,
                scaling_behavior: "DEFAULT",
                width: 960
              },
            ],
          },
          input_specification: {
            codec: "AVC", # accepts MPEG2, AVC, HEVC
            maximum_bitrate: "MAX_10_MBPS", # accepts MAX_10_MBPS, MAX_20_MBPS, MAX_50_MBPS
            resolution: "SD", # accepts SD, HD, UHD
          },
          role_arn: 'arn:aws:iam::081999022144:role/screade-live-streame-with-me-MediaLiveRole1149D189-32EJTK8LEY41'
        })
        
        response[0]
      rescue
        nil
      end
    end
    
  end
end
