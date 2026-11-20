# CineDeb

**Structured movie debates on your phone.** CineDeb is a Flutter app where film fans review movies and challenge each other's reviews with counter-reviews.

> CS310 Mobile Application Development – Term Project, Group 4 (2026–2027)

## Group Members

| Name | Student ID |
|------|------------|
| Ediz Karlı | 33806 |
| Muhammad Basil Khan | 33540 |
| Humayl Hafeez Soomro | 33548 |
| İzzet Balçık | 33778 |

**Repository:** https://github.com/EdizKarli/CS310-Project_Group-4

## Project Task

CineDeb is our CS310 term project. It is built in steps, and each step builds on the previous one:

| Step | What we deliver |
|------|-----------------|
| Step 1 – Proposal | The app idea, target users and core features |
| Step 2.1 – Wireframes | A wireframe for every core screen, showing the layout and how users move between screens |
| Step 2.2 – Flutter UI | The approved screens built in Flutter with working navigation |
| Step 3 – Firebase | Real authentication and data using Firebase |

### Step 2.2 – Flutter UI

In this step we turn the wireframes into a working Flutter interface:

- Build the approved screens with working navigation. Placeholder data is used for now; Firebase comes in Step 3.
- Login and Sign Up are UI only – there is no real authentication yet.
- Keep the design consistent by using shared files for colors, text styles and spacing, and reusable widgets.
- Screens must work on small and large phones in portrait mode without overflow errors.
- Include local and network images, a custom font, and a list of model objects shown in `Card` widgets with a working remove action.
- Include a form with at least two fields, inline validation errors and a confirmation dialog after a valid submission.

## About the App

### The problem

On platforms such as IMDb or Letterboxd, reviews are isolated opinions. If you disagree with a review, the discussion happens in a messy comment section that easily drifts off topic, and replies get mixed up. There is no structured way for movie lovers to challenge or refine a specific critique.

### Our solution

CineDeb is built for structured movie discussions. Users discover films, read reviews and write **counter-reviews** directly under an existing review. To keep debates focused and comfortable to read on a phone, counter-reviews are limited to **one level**: the original critic and the counter-reviewers talk under a single review, with no endless reply chains.

### Who it is for

Film enthusiasts and casual moviegoers who want to read balanced viewpoints instead of one-sided reviews, and who enjoy healthy debates about cinema.

### Key features

- **Discover movies** – Trending Now, Hot Debates and a sortable list of all movies on the Home screen.
- **Search and filter** – search by title, year or rating, and filter the results by year, rating and genre.
- **Reviews** – read reviews with a 1–10 rating, like or dislike them, and sort them.
- **Counter-reviews** – challenge any review with a counter-review, one level deep.
- **Write a review** – rate a movie from 1 to 10 and write a review of 20–500 characters.
- **Profile** – see your stats, your reviews and your counter-reviews, and delete them.

## Screens

| # | Screen | What it does |
|---|--------|--------------|
| 1 | Login | Log in with an email or @handle and a password. Links to Sign Up and Forgot Password. |
| 2 | Sign Up | Create an account with a handle, an email and a password. |
| 3 | Forgot Password | Ask for a password reset link by email. |
| 4 | Home / Discover | The main hub: search bar, quick-access tiles, Trending Now, Hot Debates and All Movies. |
| 5 | Search Results | Movies that match a search, with Year, Rating and Genre filters and a sort option. |
| 6 | Movie Detail | Poster, year, genres, average rating, summary and the top reviews of one movie. |
| 7 | Reviews | All reviews of a movie, with Like, Dislike, Counter Reviews and Challenge buttons. |
| 8 | Counter Reviews | The original review at the top and all of its counter-reviews below it. |
| 9 | Write Review | A form with a 1–10 rating and the review text, inline errors and a confirmation dialog. |
| 10 | Profile | Your stats, your reviews and counter-reviews (with Delete), and Log Out. |

### Navigation flow

1. The app opens on **Login**. New users go to **Sign Up**.
2. After logging in or signing up, the user lands on **Home**.
3. From Home, the user searches for a movie (→ **Search Results**) or taps a movie (→ **Movie Detail**).
4. On Movie Detail, the user reads the top reviews or taps **Write a Review**.
5. Any review can be challenged from **Reviews** or **Counter Reviews**.
6. The bottom bar switches between **Home** and **Profile**. **Log Out** on Profile goes back to Login.

## Getting Started

### Requirements

| Tool | Version we use |
|------|----------------|
| Flutter | **3.50.0** (stable channel) |
| Dart | 3.14.0 (comes with Flutter) |
| Android SDK | API 36 (installed with Android Studio) |
| Emulator | Pixel 9a, Android API 36 |

Check your setup with:

```bash
flutter --version
flutter doctor
```

### Run the app

1. Clone the repository and open the folder:
   ```bash
   git clone https://github.com/EdizKarli/CS310-Project_Group-4.git
   cd CS310-Project_Group-4
   ```
2. Install the packages:
   ```bash
   flutter pub get
   ```
3. Start an Android emulator, either from Android Studio (**Device Manager → ▶**) or from the terminal:
   ```bash
   flutter emulators                         # list your emulators
   flutter emulators --launch <emulator_id>  # e.g. Pixel_9a
   ```
4. Run the app:
   ```bash
   flutter run
   ```

> The project is set up for **Android** and was tested on an Android emulator.

### Logging in

Authentication is added in Step 3, so for now **any non-empty handle and password** logs you in. On Sign Up, the email has to look like an email and the password needs at least 6 characters.
