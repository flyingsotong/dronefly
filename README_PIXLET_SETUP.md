# Dronefly Analytics Pixlet App

This is a simple Pixlet app that displays website analytics for your Dronefly website on a Tidbyt device.

## What You've Built

Your `dronefly_analytics.star` app:
- Fetches analytics data from Umami (a privacy-focused analytics platform)
- Displays visitor count and page views
- Animates between the two metrics
- Can be configured for different time periods (24h, 7d, 30d, etc.)

## Key Improvements Made

1. **Fixed the API call bug** - The original code had misplaced code that would cause errors
2. **Added better number formatting** - Large numbers show as "1.2K" or "1.5M" instead of long numbers
3. **Added animation** - The display alternates between showing visitors and page views
4. **Improved error handling** - Better error messages if the API fails
5. **Enhanced visual design** - Better fonts and colors for the LED display

## How to Use

### Prerequisites
- Pixlet installed (✅ Done!)
- Umami analytics set up for your website
- A Tidbyt device (optional for testing)

### Testing Locally
1. **Render a static image:**
   ```bash
   pixlet render dronefly_analytics.star
   ```
   This creates a `dronefly_analytics.webp` file you can view.

2. **Run the development server:**
   ```bash
   pixlet serve dronefly_analytics.star
   ```
   Then open http://localhost:8080 in your browser to see the live preview.

### Customizing for Your Website

To use this with your actual Dronefly website analytics:

1. **Set up Umami Analytics:**
   - Sign up for Umami Cloud (https://umami.is) or self-host
   - Add your dronefly website to Umami
   - Get the tracking code and add it to your website

2. **Get Your Share ID:**
   - In Umami dashboard, go to your website settings
   - Look for "Share URL" or "Public URL"
   - Copy the ID from the URL (it looks like: `8894fbc1-d127-4d15-84aa-27fa8a2d0bf4`)

3. **Update the app:**
   - Open `dronefly_analytics.star`
   - Replace the `SHARE_ID` value with your actual share ID
   - If using a different Umami instance, update `UMAMI_URL`

### Deploying to Tidbyt

1. **Install the Tidbyt mobile app**
2. **Push your app:**
   ```bash
   pixlet push --api-token YOUR_API_TOKEN dronefly_analytics.star
   ```
3. **Configure in the app** - You can change settings like time period directly from your phone

## File Structure

```
/Users/alansoon/Documents/dronefly/
├── dronefly_analytics.star    # Your Pixlet app
├── README_PIXLET_SETUP.md     # This guide
└── [your website files...]    # Your existing dronefly website
```

## Next Steps

1. **Set up Umami analytics** on your dronefly website
2. **Get your share ID** from Umami
3. **Update the app** with your real analytics data
4. **Test with real data** using `pixlet serve`
5. **Deploy to your Tidbyt** device

## Troubleshooting

- **"API request failed"** - Check your share ID and Umami URL
- **"Failed to decode JSON"** - The API might be returning an error, check your Umami setup
- **No data showing** - Make sure your website has some traffic and the share URL is public

## Learning Resources

- [Pixlet Documentation](https://tidbyt.dev/)
- [Umami Analytics](https://umami.is/docs)
- [Starlark Language Guide](https://github.com/bazelbuild/starlark/blob/master/spec.md)

Happy coding! 🚁✨
