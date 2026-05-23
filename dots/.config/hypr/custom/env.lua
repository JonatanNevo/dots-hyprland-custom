-- Nvidia
hl.env("LIBVA_DRIVER_NAME", "nvidia")
hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")
hl.env("__EGL_VENDOR_LIBRARY_FILENAMES", "/usr/share/glvnd/egl_vendor.d/10_nvidia.json")

-- Proton
hl.env("PROTON_DLSS_UPGRADE", "1")
-- hl.env("PROTON_DLSS_INDICATOR", "1")

-- Wayland
hl.env("PROTON_ENABLE_WAYLAND", "1")

-- HDR
hl.env("PROTON_ENABLE_HDR", "1")

-- Unreal Engine Fixes
hl.env("UE_CEFSANDBOX", "0")
