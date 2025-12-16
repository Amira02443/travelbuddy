"""
Generate placeholder images for TravelBuddy activities.
Requires: pip install pillow
"""
import os
from PIL import Image, ImageDraw, ImageFont
import random

# List of all image filenames from activities.xml
IMAGE_FILES = [
    "eiffel.jpg",
    "louvre.jpg",
    "seine.jpg",
    "montmartre.jpg",
    "jules-verne.jpg",
    "moulin-rouge.jpg",
    "luxembourg.jpg",
    "galeries.jpg",
    "colosseum.jpg",
    "vatican.jpg",
    "trevi.jpg",
    "pantheon.jpg",
    "sagrada.jpg",
    "park-guell.jpg",
    "gothic-quarter.jpg",
]

OUTPUT_DIR = r"c:\Users\ASUS\travelbuddy\backend\travelbuddy-jakarta\src\main\resources\images"

# Color palettes for different cities
COLOR_PALETTES = {
    "paris": [(100, 150, 200), (200, 180, 100)],  # Blue + Gold
    "rome": [(180, 100, 80), (200, 150, 100)],     # Brown + Tan
    "barcelona": [(200, 100, 50), (255, 200, 0)],  # Orange + Gold
}

def get_city_from_name(filename):
    """Infer city from filename."""
    if any(x in filename for x in ["eiffel", "louvre", "seine", "montmartre", "jules", "moulin", "luxembourg", "galeries"]):
        return "paris"
    elif any(x in filename for x in ["colosseum", "vatican", "trevi", "pantheon"]):
        return "rome"
    elif any(x in filename for x in ["sagrada", "park", "gothic"]):
        return "barcelona"
    return "other"

def generate_placeholder_image(filename, city):
    """Generate a placeholder image with activity name."""
    width, height = 800, 600
    
    # Get colors for the city
    colors = COLOR_PALETTES.get(city, [(100, 150, 200), (200, 150, 100)])
    bg_color = colors[0]
    accent_color = colors[1]
    
    # Create image with gradient effect
    img = Image.new('RGB', (width, height), bg_color)
    draw = ImageDraw.Draw(img)
    
    # Draw accent stripe
    draw.rectangle([(0, height // 2), (width, height)], fill=accent_color)
    
    # Add text
    activity_name = filename.replace(".jpg", "").replace("-", " ").title()
    
    # Try to use a nice font, fallback to default
    try:
        font = ImageFont.truetype("arial.ttf", 60)
        small_font = ImageFont.truetype("arial.ttf", 30)
    except:
        font = ImageFont.load_default()
        small_font = ImageFont.load_default()
    
    # Draw text
    bbox = draw.textbbox((0, 0), activity_name, font=font)
    text_width = bbox[2] - bbox[0]
    text_x = (width - text_width) // 2
    
    draw.text((text_x, height // 3), activity_name, fill=(255, 255, 255), font=font)
    draw.text((50, height - 100), f"📍 {city.upper()}", fill=(255, 255, 255), font=small_font)
    
    # Save
    filepath = os.path.join(OUTPUT_DIR, filename)
    img.save(filepath, "JPEG", quality=85)
    print(f"✓ Generated: {filename}")

def main():
    """Generate all placeholder images."""
    os.makedirs(OUTPUT_DIR, exist_ok=True)
    
    print(f"Generating placeholder images in: {OUTPUT_DIR}\n")
    
    for filename in IMAGE_FILES:
        city = get_city_from_name(filename)
        generate_placeholder_image(filename, city)
    
    print(f"\n✓ Generated {len(IMAGE_FILES)} placeholder images!")

if __name__ == "__main__":
    main()
