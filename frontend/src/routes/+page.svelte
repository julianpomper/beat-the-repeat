<script lang="ts">
    import spotify from '../lib/images/spotify.png';
    import { API_URL } from "../helper/constants";
</script>

<svelte:head>
    <title>Beat the Repeat</title>
    <meta name="description" content="Get started with Beat the Repeat"/>
</svelte:head>

<div class="max-w-md flex flex-col items-start justify-center">
    <h2 class="text-5xl font-bold text-white">
        Beat the Repeat
    </h2>
    <p class="mt-4 text-xl text-gray-300">
        Never ever listen twice to a song in<br> your playlist again!
    </p>
    <div class="mt-10 flex items-center gap-x-4 bg-white px-4 py-3 rounded-md hover:bg-gray-100 hover:scale-105 transition-all cursor-pointer">
        <img alt="Spotify logo"
             class="w-6 h-6"
             src={spotify}>
        <a href={API_URL}
           class="text-sm font-bold text-gray-900 shadow-sm">
            GET STARTED
        </a>
    </div>
</div>
