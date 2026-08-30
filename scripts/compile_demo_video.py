import os
import glob
from PIL import Image

feedback_dir = r"C:\Users\madha\.gemini\antigravity\brain\45b5e5cc-c5f1-413f-8519-1b477399e92f\.system_generated\click_feedback"
pattern = os.path.join(feedback_dir, "click_feedback_17880878*.png")
pattern_2 = os.path.join(feedback_dir, "click_feedback_17880879*.png")
pattern_3 = os.path.join(feedback_dir, "click_feedback_17880880*.png")
pattern_4 = os.path.join(feedback_dir, "click_feedback_17880881*.png")
pattern_5 = os.path.join(feedback_dir, "click_feedback_17880882*.png")
pattern_6 = os.path.join(feedback_dir, "click_feedback_17880883*.png")

png_files = sorted(
    glob.glob(pattern) + 
    glob.glob(pattern_2) + 
    glob.glob(pattern_3) + 
    glob.glob(pattern_4) + 
    glob.glob(pattern_5) + 
    glob.glob(pattern_6)
)

print(f"Found {len(png_files)} demo frames.")

frames = []
for file_path in png_files:
    img = Image.open(file_path).convert("RGB")
    # Resize to standard HD frame 1280x720 for optimal performance & compatibility
    img_resized = img.resize((1280, 720), Image.Resampling.LANCZOS)
    frames.append(img_resized)

if frames:
    dest_1 = r"d:\SentinelMesh-Governance-Platform\SentinelMesh_Demo_Video.webp"
    dest_2 = r"d:\SentinelMesh-Governance-Platform\artifacts\sentinelmesh\public\SentinelMesh_Demo_Video.webp"
    dest_3 = r"d:\SentinelMesh-Governance-Platform\artifacts\sentinelmesh_4min_demo_video.webp"
    
    # Save as animated WebP with 2500ms (2.5s) per slide for clear presentation
    frames[0].save(
        dest_1,
        save_all=True,
        append_images=frames[1:],
        duration=2500,
        loop=0,
        quality=80
    )
    print(f"Saved {dest_1} ({os.path.getsize(dest_1)} bytes)")
    
    frames[0].save(
        dest_2,
        save_all=True,
        append_images=frames[1:],
        duration=2500,
        loop=0,
        quality=80
    )
    print(f"Saved {dest_2} ({os.path.getsize(dest_2)} bytes)")

    frames[0].save(
        dest_3,
        save_all=True,
        append_images=frames[1:],
        duration=2500,
        loop=0,
        quality=80
    )
    print(f"Saved {dest_3} ({os.path.getsize(dest_3)} bytes)")
