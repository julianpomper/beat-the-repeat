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

<div class="max-w-md flex flex-col items-start justify-center">
    {#if $userStore !== undefined}
        <img alt="Profile" src={$userStore.imageUrl}
             class="aspect-square self-center h-36 rounded-full border-2 border-white">
        <h2 class="mt-10 text-4xl font-bold text-white leading-6">
            <span class="text-lg font-normal text-gray-300">
                Hello
            </span>
            <br>
            {$userStore.name}
        </h2>
        <p class="mt-4 text-lg text-gray-300">
            Configure the settings of your<br><span class="font-bold">Beat the Repeat</span>
            playlist!
            <br>
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
        <small class="absolute bottom-4 left-1/2 -translate-x-1/2 text-center text-white opacity-40">Attention: The
            played songs of the selected playlist will be deleted!</small>
    {:else}
        <div class="text-xl font-semibold">Loading</div>
    {/if}
</div>
