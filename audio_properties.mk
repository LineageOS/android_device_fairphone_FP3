# audio_properties.mk
#
# Product-specific audio property definitions.
# Taken as it is from vendor/qcom/opensource/audio-hal/primary-hal/configs/msm8953/msm8953.mk
#

# Reduce client buffer size for fast audio output tracks
PRODUCT_VENDOR_PROPERTIES += \
    af.fast_track_multiplier=1

#Low latency audio buffer size in frames
PRODUCT_VENDOR_PROPERTIES += \
    vendor.audio_hal.period_size=192

##fluencetype can be "fluence" or "fluencepro" or "none"
PRODUCT_VENDOR_PROPERTIES += \
    ro.vendor.audio.sdk.fluencetype=none \
    persist.vendor.audio.fluence.voicecall=true \
    persist.vendor.audio.fluence.voicerec=false \
    persist.vendor.audio.fluence.speaker=true

#disable tunnel encoding
PRODUCT_VENDOR_PROPERTIES += \
    vendor.audio.tunnel.encode=false

#Buffer size in kbytes for compress offload playback
PRODUCT_VENDOR_PROPERTIES += \
    vendor.audio.offload.buffer.size.kb=64

#Minimum duration for offload playback in secs
PRODUCT_VENDOR_PROPERTIES += \
    audio.offload.min.duration.secs=30

#Enable offload audio video playback by default
PRODUCT_VENDOR_PROPERTIES += \
    audio.offload.video=true

#Enable audio track offload by default
PRODUCT_VENDOR_PROPERTIES += \
    vendor.audio.offload.track.enable=true

#Enable music through deep buffer
PRODUCT_VENDOR_PROPERTIES += \
    audio.deep_buffer.media=true

#enable voice path for PCM VoIP by default
PRODUCT_VENDOR_PROPERTIES += \
    vendor.voice.path.for.pcm.voip=true

#Enable multi channel aac through offload
PRODUCT_VENDOR_PROPERTIES += \
    vendor.audio.offload.multiaac.enable=true

#Enable DS2, Hardbypass feature for Dolby
PRODUCT_VENDOR_PROPERTIES += \
    vendor.audio.dolby.ds2.enabled=false \
    vendor.audio.dolby.ds2.hardbypass=false

#Disable Multiple offload sesison
PRODUCT_VENDOR_PROPERTIES += \
    vendor.audio.offload.multiple.enabled=false

#Disable Compress passthrough playback
PRODUCT_VENDOR_PROPERTIES += \
    vendor.audio.offload.passthrough=false

#Disable surround sound recording
PRODUCT_VENDOR_PROPERTIES += \
    ro.vendor.audio.sdk.ssr=false

#enable dsp gapless mode by default
PRODUCT_VENDOR_PROPERTIES += \
    vendor.audio.offload.gapless.enabled=true

#enable pbe effects
PRODUCT_VENDOR_PROPERTIES += \
    vendor.audio.safx.pbe.enabled=true

#parser input buffer size(256kb) in byte stream mode
PRODUCT_VENDOR_PROPERTIES += \
    vendor.audio.parser.ip.buffer.size=262144

#enable downsampling for multi-channel content > 48Khz
PRODUCT_VENDOR_PROPERTIES += \
    vendor.audio.playback.mch.downsample=true

#enable software decoders for ALAC and APE.
PRODUCT_VENDOR_PROPERTIES += \
    vendor.audio.use.sw.alac.decoder=false \
    vendor.audio.use.sw.ape.decoder=true

#property for AudioSphere Post processing
PRODUCT_VENDOR_PROPERTIES += \
    vendor.audio.pp.asphere.enabled=false

#Audio voice concurrency related flags
PRODUCT_VENDOR_PROPERTIES += \
    vendor.voice.playback.conc.disabled=true \
    vendor.voice.record.conc.disabled=false \
    vendor.voice.voip.conc.disabled=true

#Decides the audio fallback path during voice call,
#deep-buffer and fast are the two allowed fallback paths now.
PRODUCT_VENDOR_PROPERTIES += \
    vendor.voice.conc.fallbackpath=deep-buffer

#Disable speaker protection by default
PRODUCT_VENDOR_PROPERTIES += \
    persist.vendor.audio.speaker.prot.enable=false

#Enable HW AAC Encoder by default
PRODUCT_VENDOR_PROPERTIES += \
    vendor.audio.hw.aac.encoder=true

#flac sw decoder 24 bit decode capability
PRODUCT_VENDOR_PROPERTIES += \
    vendor.audio.flac.sw.decoder.24bit=true

#timeout crash duration set to 20sec before system is ready.
#timeout duration updates to default timeout of 5sec once the system is ready.
PRODUCT_VENDOR_PROPERTIES += \
    vendor.audio.hal.boot.timeout.ms=20000

#read wsatz name from thermal zone type
PRODUCT_VENDOR_PROPERTIES += \
    vendor.audio.read.wsatz.type=true

#Set AudioFlinger client heap size
PRODUCT_VENDOR_PROPERTIES += \
    ro.af.client_heap_size_kbyte=7168

PRODUCT_VENDOR_PROPERTIES += \
    persist.vendor.audio.hw.binder.size_kbyte=1024

#Set speaker protection cal tx path sampling rate to 48k
PRODUCT_VENDOR_PROPERTIES += \
    vendor.audio.spkr_prot.tx.sampling_rate=48000

PRODUCT_VENDOR_PROPERTIES += \
    ro.config.vc_call_vol_steps=7

# add dynamic feature flags here
PRODUCT_VENDOR_PROPERTIES += \
    vendor.audio.feature.snd_mon.enable=true \
    vendor.audio.feature.compr_cap.enable=false \
    vendor.audio.feature.hifi_audio.enable=true \
    vendor.audio.feature.hdmi_edid.enable=true  \
    vendor.audio.feature.dsm_feedback.enable=false \
    vendor.audio.feature.ssrec.enable=true  \
    vendor.audio.feature.compr_voip.enable=true \
    vendor.audio.feature.kpi_optimize.enable=true \
    vendor.audio.feature.usb_offload.enable=false  \
    vendor.audio.feature.usb_offload_burst_mode.enable=false \
    vendor.audio.feature.usb_offload_sidetone_volume.enable=false \
    vendor.audio.feature.src_trkn.enable=true \
    vendor.audio.feature.ras.enable=false \
    vendor.audio.feature.a2dp_offload.enable=false \
    vendor.audio.feature.wsa.enable=true \
    vendor.audio.feature.compress_meta_data.enable=true \
    vendor.audio.feature.vbat.enable=true \
    vendor.audio.feature.display_port.enable=false \
    vendor.audio.feature.fluence.enable=true \
    vendor.audio.feature.custom_stereo.enable=true \
    vendor.audio.feature.anc_headset.enable=true \
    vendor.audio.feature.spkr_prot.enable=false \
    vendor.audio.feature.fm.enable=true \
    vendor.audio.feature.external_dsp.enable=false \
    vendor.audio.feature.external_speaker.enable=false \
    vendor.audio.feature.external_speaker_tfa.enable=false \
    vendor.audio.feature.hwdep_cal.enable=false \
    vendor.audio.feature.hfp.enable=true \
    vendor.audio.feature.ext_hw_plugin.enable=false \
    vendor.audio.feature.record_play_concurency.enable=false \
    vendor.audio.feature.hdmi_passthrough.enable=false \
    vendor.audio.feature.concurrent_capture.enable=false \
    vendor.audio.feature.compress_in.enable=false \
    vendor.audio.feature.battery_listener.enable=false \
    vendor.audio.feature.maxx_audio.enable=false \
    vendor.audio.feature.audiozoom.enable=false \
    vendor.audio.feature.auto_hal.enable=false \
    vendor.audio.read.wsatz.type=true \
    vendor.audio.feature.multi_voice_session.enable=true \
    vendor.audio.feature.incall_music.enable=true

