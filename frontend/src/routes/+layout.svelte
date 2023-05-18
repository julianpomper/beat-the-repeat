<script lang="ts">
    import "../app.css";
    import { goto } from '$app/navigation';
    import { getSession } from "../helper/cookie";
    import { onMount } from "svelte";

    onMount(() => {
        const token = getSession();
        if (token.length <= 0) {
            goto("/");
        } else {
            goto("/home");
        }
    });
</script>

<div>
    <main>
        <slot/>
    </main>
</div>
