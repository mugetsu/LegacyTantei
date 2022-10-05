//
//  MockData.swift
//  Tantei-san
//
//  Created by Randell on 1/10/22.
//

import Foundation

struct MockData {
    static let topAnime: [Jikan.AnimeDetails] = [
        Jikan.AnimeDetails(
            malId: 1,
            images: Jikan.AnimeImages(
                webp: Jikan.AnimeImageURL(
                    regular: "",
                    small: "",
                    large: ""
                )
            ),
            titles: [
                Jikan.AnimeTitle(
                    type: "",
                    title: ""
                )
            ],
            airing: true,
            aired: Jikan.AnimeAired(
                from: "",
                to: ""
            ),
            rating: "",
            score: 99.0,
            rank: 1,
            popularity: 1,
            favorites: 1,
            synopsis: "",
            year: 2022,
            studios: [
                Jikan.AnimeMetaData(
                    type: "",
                    name: ""
                )
            ],
            genres: [
                Jikan.AnimeMetaData(
                    type: "",
                    name: ""
                )
            ],
            themes: [
                Jikan.AnimeMetaData(
                    type: "",
                    name: ""
                )
            ],
            demographics: [
                Jikan.AnimeMetaData(
                    type: "",
                    name: ""
                )
            ],
            trailer: Jikan.AnimeTrailer(
                embedURL: "",
                images: Jikan.AnimeImageURL(
                    regular: "",
                    small: "",
                    large: ""
                )
            ),
            type: "", episodes: 1
        )
    ]
    
    static let animeByURL: [Trace.AnimeDetails] = [
        Trace.AnimeDetails(
            anilist: Trace.AnimeAniList(
                id: 104578,
                idMal: 38524,
                title: Trace.AnimeAniListTitle(
                    native: "進撃の巨人３ Part.2",
                    romaji: "Shingeki no Kyojin 3 Part 2",
                    english: "Attack on Titan Season 3 Part 2"
                ),
                isAdult: false
            ),
            episode: 8,
            from: 865.33,
            to: 868.25,
            similarity: 0.8481807944128712,
            image: "https://media.trace.moe/image/104578/%5BOhys-Raws%5D%20Shingeki%20no%20Kyojin%20Season%203%20(2019)%20-%2010%20END%20(NHKG%201280x720%20x264%20AAC).mp4.jpg?t=866.79&now=1664618400&token=AWFKL0R16AeTOfIcpWSVnNVliw"
        ),
        Trace.AnimeDetails(
            anilist: Trace.AnimeAniList(
                id: 6090,
                idMal: 6090,
                title: Trace.AnimeAniListTitle(
                    native: "紅狼",
                    romaji: "Hon Ran",
                    english: "Crimson Wolf"
                ),
                isAdult: true
            ),
            from: 636.58,
            to: 641.83,
            similarity: 0.7691477992183592,
            image: "https://media.trace.moe/image/6090/%E7%BA%A2%E7%8B%BC(640%C3%97480%20x264%20AAC).mp4.jpg?t=639.205&now=1664618400&token=mGSsFnPULnjYkhkO6rsj1ca8Czs"
        ),
        Trace.AnimeDetails(
            anilist: Trace.AnimeAniList(
                id: 4080,
                idMal: 4080,
                title: Trace.AnimeAniListTitle(
                    native: "今日からマ王！第3シリーズ",
                    romaji: "Kyou kara Maou! 3rd Series",
                    english: "Kyo Kara Maoh! Season 3"
                ),
                isAdult: false
            ),
            episode: 33,
            from: 171.92,
            to: 173.42,
            similarity: 0.7640637227181439,
            image: "https://media.trace.moe/image/4080/%5BWOLF%5D%5BKyou%20kara%20Maou!3%5D%5B33%5D%5B704X396%5D%5BJp_Cn%5D.mp4.jpg?t=172.67&now=1664618400&token=31kP3D7Qih6drKMZRU32yKmhjA"
        ),
        Trace.AnimeDetails(
            anilist: Trace.AnimeAniList(
                id: 17389,
                idMal: 17389,
                title: Trace.AnimeAniListTitle(
                    native: "キングダム 2",
                    romaji: "Kingdom 2",
                    english: "Kingdom Season 2"
                ),
                isAdult: false
            ),
            episode: 25,
            from: 563.5,
            to: 563.58,
            similarity: 0.7618964887693741,
            image: "https://media.trace.moe/image/17389/%5BKoeisub%5D%5BKingdom2%5D%5B25%5D%5BCHT%5D%5B720p%5D.mp4.jpg?t=563.54&now=1664618400&token=E9Padiqs6BHA04JgCKgjpAuJKA0"
        ),
        Trace.AnimeDetails(
            anilist: Trace.AnimeAniList(
                id: 108146,
                idMal: 39421,
                title: Trace.AnimeAniListTitle(
                    native: "异常生物见闻录",
                    romaji: "Yichang Shengwu Jianwen Lu"
                ),
                isAdult: false
            ),
            episode: 7,
            from: 1254.67,
            to: 1255.42,
            similarity: 0.759764798145429,
            image: "https://media.trace.moe/image/108146/%5BOhys-Raws%5D%20Yichang%20Shengwu%20Jianwen%20Lu%20-%2007%20(BSFUJI%201280x720%20x264%20AAC).mp4.jpg?t=1255.045&now=1664618400&token=YXD6vY0b0qiz4l1g82k8IwNSo"
        ),
        Trace.AnimeDetails(
            anilist: Trace.AnimeAniList(
                id: 14719,
                idMal: 14719,
                title: Trace.AnimeAniListTitle(
                    native: "ジョジョの奇妙な冒険 (TV)",
                    romaji: "JoJo no Kimyou na Bouken (TV)",
                    english: "JoJo's Bizarre Adventure (TV)"
                ),
                isAdult: false
            ),
            episode: 25,
            from: 656.17,
            to: 658.17,
            similarity: 0.757428213498111,
            image: "https://media.trace.moe/image/14719/%5BKamigami%5D%20JoJo%20no%20Kimyou%20na%20Bouken%20-%2025%20%5Bx264%201280x720%20AAC%20Sub(Chs%2CJap)%5D.mp4.jpg?t=657.17&now=1664618400&token=IaUXaap48xvRDr5Sf6WfQ1Og0Y"
        )
    ]
}
