<script lang="ts">
    import spotify from '../lib/images/spotify.png';
</script>

<svelte:head>
    <title>Beat the Repeat</title>
    <meta name="description" content="Get started with Beat the Repeat"/>
</svelte:head>

<div class="w-full h-screen">
    <div class="bg-gray-900 h-full flex justify-center items-center relative">
        <div class="relative isolate overflow-hidden bg-gray-900 shadow-2xl md:rounded-3xl md:px-32 py-48 px-8">
            <svg viewBox="0 0 1024 1024"
                 class="absolute left-3/4 -translate-x-1/2 top-[120%] -translate-y-1/2 -z-10 h-[100rem] w-[100rem] [mask-image:radial-gradient(closest-side,white,transparent)]">
                <circle cx="512" cy="512" r="512" fill="url(#759c1415-0410-454c-8f7c-9a820de03641)" fill-opacity="0.2"/>
                <defs>
                    <radialGradient id="759c1415-0410-454c-8f7c-9a820de03641">
                        <stop stop-color="#7775D6"/>
                        <stop offset="1" stop-color="#E935C1"/>
                    </radialGradient>
                </defs>
            </svg>
            <div class="max-w-md flex flex-col items-start">
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
                    <a href="https://api.btr.mxgi.io"
                       class="text-sm font-bold text-gray-900 shadow-sm">
                        GET STARTED
                    </a>
                </div>
            </div>
        </div>
    </div>
</div>
