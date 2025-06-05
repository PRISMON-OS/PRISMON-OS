# GitHub Pages Update Steps

The updated website files have been pushed to the `updated-gh-pages` branch. To make these changes live on the GitHub Pages site, follow these steps:

1. Go to: https://github.com/PRISMON-OS/PRISMON-OS/pull/new/updated-gh-pages

2. Create a pull request from `updated-gh-pages` to `gh-pages` branch

3. Add a title like "Update website with new ISO variants and download links"

4. Add a description explaining the changes:
   - Updated index.html with all new ISO variants
   - Added Community Fast, Developer Fast editions
   - Updated download section with proper download links
   - Fixed Quantum Fast ISO download link
   - Added status page link

5. Create the pull request

6. Review the changes and merge the pull request

7. Wait a few minutes for GitHub Pages to deploy the changes

8. Verify the live site at: https://prismon-os.github.io/PRISMON-OS/

## Note about Large ISOs

The large ISO files (5GB+) exceed GitHub's file size limits and were not included in this push. For these files, consider:

1. Using GitHub Releases for large file hosting
2. Setting up Git LFS (Large File Storage)
3. Using an external file hosting service
4. Breaking them into smaller chunks with a reassembly script

For now, the website has been updated to show "Coming Soon" for the large Quantum Fast ISO.
