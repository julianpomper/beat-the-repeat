<script lang="ts">
    import { onMount } from "svelte";
    import { fetchPlaylists } from "../../helper/apis/playlist-api.ts";
    import { playlistsStore, userStore } from "../../helper/stores/store.ts";
    import { fetchUser, updateUser } from "../../helper/apis/user-api.ts";

    export let isActive: boolean = false;
    export let selectedPlaylistId: string | undefined = undefined;

    onMount(async () => {
        fetchUser()
            .then(user => {
                isActive = user.isActive;
                selectedPlaylistId = user.activePlaylistId;

                fetchPlaylists();
            });
    });
</script>

<svelte:head>
    <title>Home</title>
    <meta name="description" content="Manage your BTR playlist"/>
</svelte:head>

<div class="w-full h-screen">
    <div class="bg-gray-900 h-full flex justify-center items-center relative">
        <svg class="absolute left-0 top-0 w-full opacity-20" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1440 320">
            <path class="fill-black" fill-opacity="1"
                  d="M0,192L21.8,176C43.6,160,87,128,131,128C174.5,128,218,160,262,160C305.5,160,349,128,393,133.3C436.4,139,480,181,524,186.7C567.3,192,611,160,655,154.7C698.2,149,742,171,785,197.3C829.1,224,873,256,916,272C960,288,1004,288,1047,272C1090.9,256,1135,224,1178,181.3C1221.8,139,1265,85,1309,64C1352.7,43,1396,53,1418,58.7L1440,64L1440,0L1418.2,0C1396.4,0,1353,0,1309,0C1265.5,0,1222,0,1178,0C1134.5,0,1091,0,1047,0C1003.6,0,960,0,916,0C872.7,0,829,0,785,0C741.8,0,698,0,655,0C610.9,0,567,0,524,0C480,0,436,0,393,0C349.1,0,305,0,262,0C218.2,0,175,0,131,0C87.3,0,44,0,22,0L0,0Z"></path>
        </svg>
        <div class="relative isolate overflow-hidden bg-gray-900 shadow-2xl md:rounded-3xl w-full md:w-auto md:px-32 py-24 px-8">
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
            {#if $userStore !== undefined}
                <div class="max-w-md flex flex-col items-start">
                    <img alt="Profile" src={$userStore.imageUrl}
                         class="aspect-square self-center h-36 rounded-full border-2 border-white">
                    <h2 class="mt-10 text-4xl font-bold text-white leading-6">
                        <span class="text-lg font-normal text-gray-300">Hello</span><br>{$userStore.name}
                    </h2>
                    <p class="mt-4 text-lg text-gray-300">
                        Configure the settings of your<br><span class="font-bold">Beat the Repeat</span>
                        playlist!
                    </p>
                    <div class="h-0.5 w-[200%] bg-gray-700 my-6 -mx-32"></div>
                    <label for="playlists" class="block mb-1 text-sm font-medium text-gray-300">
                        Active Beat the Repeat
                    </label>
                    <label class="relative">
                        <input type="checkbox" bind:checked={isActive}
                               on:change={() => updateUser(isActive, selectedPlaylistId)}
                               value="" class="sr-only peer">
                        <div class="w-11 h-6 bg-gray-900 peer-checked:bg-green-600 peer-focus:outline-none peer-focus:ring-4 peer-focus:ring-blue-300 rounded-full peer peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-5 after:w-5 after:transition-all"></div>
                    </label>
                    <label for="playlists" class="mt-4 block mb-1 text-sm font-medium text-gray-300">
                        Select a playlist
                    </label>
                    <select id="playlists"
                            bind:value={selectedPlaylistId}
                            on:change={() => updateUser(isActive, selectedPlaylistId)}
                            class="bg-gray-900 text-white border border-gray-700 text-sm rounded-lg block w-full p-3">
                        <option value={undefined}>None</option>
                        {#each $playlistsStore as playlist}
                            <option value={playlist.id}>{playlist.name}</option>
                        {/each}
                    </select>
                </div>
            {:else}
                <div class="text-xl font-semibold">Loading</div>
            {/if}
        </div>
    </div>
</div>
