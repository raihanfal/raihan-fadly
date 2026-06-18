import React, { useState, useEffect, useRef, useMemo, useCallback } from "react";
import {
  Play, Info, Search, X, Plus, Check, Star, Clock, Menu,
  ChevronLeft, ChevronRight, Shield, Trees, Zap, Rocket,
  Sparkles, Skull, Bookmark, Pause, Volume2, VolumeX, Maximize2, Film
} from "lucide-react";

/* ---------------------------------------------------------------- */
/* DATA — semua judul ditampilkan sebagai referensi katalog umum.     */
/* Poster, sinopsis & desain adalah karya orisinal untuk demo ini.    */
/* ---------------------------------------------------------------- */

const CATEGORIES = [
  { id: "marvel",    label: "Marvel Cinematic Universe", icon: Shield,   gradient: "from-red-900 via-red-950 to-zinc-950" },
  { id: "jurassic",  label: "Jurassic Park & World",      icon: Trees,    gradient: "from-emerald-900 via-emerald-950 to-zinc-950" },
  { id: "dc",        label: "DC Universe",                icon: Zap,      gradient: "from-indigo-900 via-indigo-950 to-zinc-950" },
  { id: "scifi",     label: "Sci-Fi Epik",                icon: Rocket,   gradient: "from-violet-900 via-violet-950 to-zinc-950" },
  { id: "animation", label: "Animasi & Keluarga",         icon: Sparkles, gradient: "from-orange-900 via-orange-950 to-zinc-950" },
  { id: "horror",    label: "Horror & Thriller",          icon: Skull,    gradient: "from-stone-900 via-red-950 to-zinc-950" },
];

const MOVIES = [
  { id: 1,  title: "Iron Man",                                  year: 2008, rating: 7.9, runtime: 126, category: "marvel",
    synopsis: "Seorang miliarder jenius membangun baju zirah canggih dan menjadi pelindung tak terduga bagi dunia." },
  { id: 2,  title: "The Avengers",                               year: 2012, rating: 8.0, runtime: 143, category: "marvel",
    synopsis: "Sekelompok individu luar biasa dipersatukan untuk menghadapi ancaman yang terlalu besar bagi siapa pun sendirian." },
  { id: 3,  title: "Avengers: Endgame",                          year: 2019, rating: 8.4, runtime: 181, category: "marvel",
    synopsis: "Sisa-sisa tim pahlawan menyusun rencana terakhir untuk membalikkan kehancuran yang telah terjadi." },
  { id: 4,  title: "Guardians of the Galaxy",                    year: 2014, rating: 8.0, runtime: 121, category: "marvel",
    synopsis: "Sekumpulan buronan antariksa yang tidak akur harus bekerja sama demi menyelamatkan galaksi." },
  { id: 5,  title: "Jurassic Park",                               year: 1993, rating: 8.2, runtime: 127, category: "jurassic",
    synopsis: "Sebuah pulau wisata berisi makhluk purba yang dihidupkan kembali berubah menjadi mimpi buruk." },
  { id: 6,  title: "The Lost World: Jurassic Park",               year: 1997, rating: 6.5, runtime: 129, category: "jurassic",
    synopsis: "Sebuah ekspedisi baru ke pulau terpencil membuka babak baru petualangan penuh bahaya purba." },
  { id: 7,  title: "Jurassic World",                              year: 2015, rating: 7.0, runtime: 124, category: "jurassic",
    synopsis: "Taman hiburan generasi baru dengan makhluk hasil rekayasa genetika lepas kendali." },
  { id: 8,  title: "Jurassic World: Fallen Kingdom",              year: 2018, rating: 6.2, runtime: 128, category: "jurassic",
    synopsis: "Letusan gunung berapi memaksa misi penyelamatan dramatis bagi para penghuni pulau purba." },
  { id: 9,  title: "The Dark Knight",                            year: 2008, rating: 9.0, runtime: 152, category: "dc",
    synopsis: "Seorang vigilante bertopeng menghadapi dalang kekacauan yang menguji batas moralnya." },
  { id: 10, title: "Man of Steel",                                year: 2013, rating: 7.0, runtime: 143, category: "dc",
    synopsis: "Seorang pendatang dari planet lain belajar menerima warisan dan tujuannya di Bumi." },
  { id: 11, title: "Wonder Woman",                                year: 2017, rating: 7.4, runtime: 141, category: "dc",
    synopsis: "Seorang putri prajurit meninggalkan tanah kelahirannya untuk menghentikan perang yang mengancam manusia." },
  { id: 12, title: "Aquaman",                                     year: 2018, rating: 6.8, runtime: 143, category: "dc",
    synopsis: "Pewaris takhta bawah laut harus merebut kembali kerajaannya demi menjaga perdamaian dua dunia." },
  { id: 13, title: "Interstellar",                                year: 2014, rating: 8.7, runtime: 169, category: "scifi",
    synopsis: "Sekelompok penjelajah menempuh lubang cacing demi mencari rumah baru bagi umat manusia." },
  { id: 14, title: "Inception",                                   year: 2010, rating: 8.8, runtime: 148, category: "scifi",
    synopsis: "Seorang pencuri yang beroperasi di dunia mimpi mendapat tugas paling berbahaya dalam kariernya." },
  { id: 15, title: "Dune",                                        year: 2021, rating: 8.0, runtime: 155, category: "scifi",
    synopsis: "Pewaris sebuah keluarga bangsawan terjebak dalam perebutan kekuasaan di planet gurun yang mematikan." },
  { id: 16, title: "The Matrix",                                  year: 1999, rating: 8.7, runtime: 136, category: "scifi",
    synopsis: "Seorang programmer menemukan bahwa realitas yang ia kenal hanyalah simulasi rumit." },
  { id: 17, title: "Toy Story",                                   year: 1995, rating: 8.3, runtime: 81,  category: "animation",
    synopsis: "Sekumpulan mainan diam-diam hidup dan harus belajar tentang persahabatan saat pemiliknya tak melihat." },
  { id: 18, title: "Coco",                                        year: 2017, rating: 8.4, runtime: 105, category: "animation",
    synopsis: "Seorang anak laki-laki memasuki dunia leluhur yang penuh warna demi mengejar impian musiknya." },
  { id: 19, title: "Spider-Verse",                                year: 2018, rating: 8.4, runtime: 117, category: "animation",
    synopsis: "Seorang remaja menemukan dirinya menjadi bagian dari jaringan pahlawan lintas semesta." },
  { id: 20, title: "Encanto",                                     year: 2021, rating: 7.2, runtime: 102, category: "animation",
    synopsis: "Satu-satunya anggota keluarga ajaib tanpa kekuatan istimewa menemukan kekuatannya sendiri." },
  { id: 21, title: "A Quiet Place",                               year: 2018, rating: 7.5, runtime: 90,  category: "horror",
    synopsis: "Sebuah keluarga harus hidup dalam kesunyian total untuk menghindari makhluk yang berburu dengan suara." },
  { id: 22, title: "Get Out",                                     year: 2017, rating: 7.7, runtime: 104, category: "horror",
    synopsis: "Kunjungan ke rumah keluarga pacarnya berubah menjadi teror psikologis yang mengganggu." },
  { id: 23, title: "The Conjuring",                                year: 2013, rating: 7.5, runtime: 112, category: "horror",
    synopsis: "Sepasang peneliti paranormal dipanggil untuk menolong keluarga yang diteror kekuatan jahat." },
  { id: 24, title: "It",                                          year: 2017, rating: 7.3, runtime: 135, category: "horror",
    synopsis: "Sekelompok anak harus menghadapi entitas kuno yang mengambil bentuk dari ketakutan terdalam mereka." },
];

const SPOTLIGHT_ID = 3;

const catInfo = (id) => CATEGORIES.find((c) => c.id === id);

/* ---------------------------------------------------------------- */

function PosterArt({ movie, size = "normal" }) {
  const cat = catInfo(movie.category);
  const Icon = cat.icon;
  const iconSize = size === "large" ? 64 : 40;
  return (
    <div className={`relative w-full h-full bg-gradient-to-br ${cat.gradient} overflow-hidden flex items-end`}>
      <Icon className="absolute -right-3 -top-3 text-white/10" size={size === "large" ? 140 : 90} strokeWidth={1.2} />
      <div className="relative z-10 w-full p-3 bg-gradient-to-t from-black/80 via-black/20 to-transparent">
        <p className="text-stone-100 font-bold leading-tight text-sm line-clamp-2">{movie.title}</p>
        <p className="text-stone-400 text-xs mt-0.5">{movie.year}</p>
      </div>
    </div>
  );
}

function MovieCard({ movie, onOpen, inList, onToggleList }) {
  return (
    <div
      className="group relative shrink-0 w-[150px] sm:w-[180px] aspect-[2/3] rounded-md overflow-hidden cursor-pointer ring-1 ring-white/5 hover:ring-amber-500/60 transition-all hover:-translate-y-1 hover:shadow-xl hover:shadow-black/60"
      onClick={() => onOpen(movie)}
    >
      <PosterArt movie={movie} />
      <div className="absolute top-2 left-2 flex items-center gap-1 bg-black/60 backdrop-blur px-1.5 py-0.5 rounded text-xs text-amber-400">
        <Star size={11} fill="currentColor" /> {movie.rating}
      </div>
      <button
        onClick={(e) => { e.stopPropagation(); onToggleList(movie.id); }}
        className="absolute top-2 right-2 p-1.5 rounded-full bg-black/60 backdrop-blur opacity-0 group-hover:opacity-100 transition-opacity hover:bg-amber-500 hover:text-black text-stone-200"
        aria-label={inList ? "Hapus dari daftar" : "Tambah ke daftar"}
      >
        {inList ? <Check size={14} /> : <Plus size={14} />}
      </button>
    </div>
  );
}

function MovieRow({ category, movies, onOpen, myList, onToggleList }) {
  const scrollRef = useRef(null);
  const scroll = (dir) => {
    if (scrollRef.current) {
      scrollRef.current.scrollBy({ left: dir * 480, behavior: "smooth" });
    }
  };
  return (
    <section className="mb-9 group/row">
      <div className="flex items-center gap-2 mb-3 px-4 sm:px-8">
        <h2 className="text-stone-100 font-semibold text-base sm:text-lg tracking-wide">{category.label}</h2>
      </div>
      <div className="relative">
        <button
          onClick={() => scroll(-1)}
          className="hidden sm:flex absolute left-0 top-0 bottom-0 z-20 w-10 items-center justify-center bg-gradient-to-r from-zinc-950 to-transparent opacity-0 group-hover/row:opacity-100 transition-opacity"
          aria-label="Gulir kiri"
        >
          <ChevronLeft className="text-stone-200" />
        </button>
        <div ref={scrollRef} className="flex gap-3 overflow-x-auto scroll-smooth px-4 sm:px-8 pb-1 [scrollbar-width:none] [&::-webkit-scrollbar]:hidden">
          {movies.map((m) => (
            <MovieCard key={m.id} movie={m} onOpen={onOpen} inList={myList.includes(m.id)} onToggleList={onToggleList} />
          ))}
        </div>
        <button
          onClick={() => scroll(1)}
          className="hidden sm:flex absolute right-0 top-0 bottom-0 z-20 w-10 items-center justify-center bg-gradient-to-l from-zinc-950 to-transparent opacity-0 group-hover/row:opacity-100 transition-opacity"
          aria-label="Gulir kanan"
        >
          <ChevronRight className="text-stone-200" />
        </button>
      </div>
    </section>
  );
}

function PreviewPlayer({ movie }) {
  const [playing, setPlaying] = useState(false);
  const [muted, setMuted] = useState(false);
  const [progress, setProgress] = useState(0);

  useEffect(() => {
    if (!playing) return;
    const interval = setInterval(() => {
      setProgress((p) => (p >= 100 ? 0 : p + 1.4));
    }, 180);
    return () => clearInterval(interval);
  }, [playing]);

  const cat = catInfo(movie.category);
  const Icon = cat.icon;

  return (
    <div className={`relative w-full aspect-video bg-gradient-to-br ${cat.gradient} flex items-center justify-center overflow-hidden`}>
      <Icon className="absolute text-white/5" size={220} strokeWidth={1} />
      <span className="absolute top-3 left-3 text-[10px] uppercase tracking-wider bg-black/50 text-stone-300 px-2 py-1 rounded">
        Mode pratinjau · bukan video asli
      </span>
      <button
        onClick={() => setPlaying((p) => !p)}
        className="relative z-10 flex items-center justify-center w-16 h-16 rounded-full bg-black/50 hover:bg-amber-500 hover:text-black text-stone-100 transition-colors"
        aria-label={playing ? "Pause" : "Play"}
      >
        {playing ? <Pause size={26} fill="currentColor" /> : <Play size={26} fill="currentColor" />}
      </button>
      <div className="absolute bottom-0 left-0 right-0 px-3 pb-2">
        <div className="h-1 w-full bg-white/20 rounded-full overflow-hidden mb-2">
          <div className="h-full bg-amber-500 transition-all" style={{ width: `${progress}%` }} />
        </div>
        <div className="flex items-center justify-between text-stone-200">
          <button onClick={() => setMuted((m) => !m)} aria-label="Volume" className="hover:text-amber-400">
            {muted ? <VolumeX size={16} /> : <Volume2 size={16} />}
          </button>
          <button aria-label="Fullscreen" className="hover:text-amber-400">
            <Maximize2 size={16} />
          </button>
        </div>
      </div>
    </div>
  );
}

function MovieModal({ movie, onClose, inList, onToggleList }) {
  useEffect(() => {
    const onKey = (e) => { if (e.key === "Escape") onClose(); };
    window.addEventListener("keydown", onKey);
    return () => window.removeEventListener("keydown", onKey);
  }, [onClose]);

  if (!movie) return null;
  const cat = catInfo(movie.category);

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/80 backdrop-blur-sm p-3" onClick={onClose}>
      <div
        className="bg-zinc-900 w-full max-w-xl rounded-lg overflow-hidden ring-1 ring-white/10 max-h-[90vh] overflow-y-auto"
        onClick={(e) => e.stopPropagation()}
      >
        <div className="relative">
          <PreviewPlayer movie={movie} />
          <button
            onClick={onClose}
            className="absolute top-3 right-3 p-1.5 rounded-full bg-black/60 hover:bg-black/80 text-stone-200"
            aria-label="Tutup"
          >
            <X size={18} />
          </button>
        </div>
        <div className="p-5">
          <h3 className="text-stone-50 text-xl font-bold tracking-wide" style={{ fontFamily: "'Bebas Neue', sans-serif" }}>
            {movie.title}
          </h3>
          <div className="flex items-center gap-3 mt-2 text-sm text-stone-400">
            <span className="flex items-center gap-1 text-amber-400"><Star size={13} fill="currentColor" /> {movie.rating}</span>
            <span>{movie.year}</span>
            <span className="flex items-center gap-1"><Clock size={13} /> {movie.runtime} min</span>
            <span className="px-1.5 py-0.5 rounded bg-white/5 text-xs">{cat.label}</span>
          </div>
          <p className="text-stone-300 text-sm mt-3 leading-relaxed">{movie.synopsis}</p>
          <div className="flex items-center gap-2 mt-4">
            <button
              onClick={() => onToggleList(movie.id)}
              className={`flex items-center gap-1.5 px-3 py-2 rounded text-sm font-medium transition-colors ${
                inList ? "bg-stone-200 text-zinc-900" : "bg-white/10 text-stone-100 hover:bg-white/20"
              }`}
            >
              {inList ? <Check size={15} /> : <Plus size={15} />}
              {inList ? "Di Daftar Saya" : "Tambah ke Daftar"}
            </button>
            <button className="flex items-center gap-1.5 px-3 py-2 rounded text-sm font-medium bg-amber-500 text-zinc-950 hover:bg-amber-400 transition-colors">
              <Info size={15} /> Detail Lengkap
            </button>
          </div>
        </div>
      </div>
    </div>
  );
}

function Reel() {
  return (
    <div className="hidden lg:flex flex-col items-center gap-3 w-6 fixed left-0 top-0 bottom-0 z-30 py-6 bg-zinc-950/40">
      {Array.from({ length: 24 }).map((_, i) => (
        <div key={i} className="w-2.5 h-2.5 rounded-full bg-zinc-700/60" />
      ))}
    </div>
  );
}

/* ---------------------------------------------------------------- */

export default function CineVault() {
  const [myList, setMyList] = useState([]);
  const [listLoaded, setListLoaded] = useState(false);
  const [view, setView] = useState("home");
  const [query, setQuery] = useState("");
  const [activeCat, setActiveCat] = useState("all");
  const [sortBy, setSortBy] = useState("default");
  const [selected, setSelected] = useState(null);
  const [menuOpen, setMenuOpen] = useState(false);

  useEffect(() => {
    (async () => {
      try {
        const res = await window.storage.get("mylist");
        setMyList(res ? JSON.parse(res.value) : []);
      } catch {
        setMyList([]);
      } finally {
        setListLoaded(true);
      }
    })();
  }, []);

  const persistList = useCallback(async (next) => {
    try {
      await window.storage.set("mylist", JSON.stringify(next), false);
    } catch {
      /* gagal menyimpan, tetap pertahankan state lokal */
    }
  }, []);

  const toggleList = useCallback((id) => {
    setMyList((prev) => {
      const next = prev.includes(id) ? prev.filter((x) => x !== id) : [...prev, id];
      persistList(next);
      return next;
    });
  }, [persistList]);

  const spotlight = MOVIES.find((m) => m.id === SPOTLIGHT_ID);

  const filtered = useMemo(() => {
    let list = MOVIES;
    if (activeCat !== "all") list = list.filter((m) => m.category === activeCat);
    if (query.trim()) {
      const q = query.toLowerCase();
      list = list.filter((m) => m.title.toLowerCase().includes(q) || catInfo(m.category).label.toLowerCase().includes(q));
    }
    const sorted = [...list];
    if (sortBy === "rating-desc") sorted.sort((a, b) => b.rating - a.rating);
    if (sortBy === "year-desc") sorted.sort((a, b) => b.year - a.year);
    if (sortBy === "title-asc") sorted.sort((a, b) => a.title.localeCompare(b.title));
    return sorted;
  }, [query, activeCat, sortBy]);

  const isFiltering = query.trim() !== "" || activeCat !== "all" || sortBy !== "default";

  const myListMovies = MOVIES.filter((m) => myList.includes(m.id));

  return (
    <div className="min-h-screen bg-zinc-950 text-stone-200 lg:pl-6">
      <style>{`
        @import url('https://fonts.googleapis.com/css2?family=Bebas+Neue&family=Inter:wght@400;500;600;700&display=swap');
        * { font-family: 'Inter', sans-serif; }
        .brand { font-family: 'Bebas Neue', sans-serif; letter-spacing: 0.06em; }
      `}</style>
      <Reel />

      {/* NAVBAR */}
      <header className="fixed top-0 left-0 right-0 z-40 lg:left-6">
        <div className="bg-gradient-to-b from-zinc-950 via-zinc-950/90 to-transparent">
          <div className="flex items-center justify-between px-4 sm:px-8 py-4">
            <div className="flex items-center gap-6">
              <span className="brand text-amber-400 text-2xl">CINEVAULT</span>
              <nav className="hidden md:flex items-center gap-5 text-sm text-stone-300">
                <button onClick={() => setView("home")} className={`hover:text-stone-50 transition-colors ${view === "home" ? "text-stone-50 font-semibold" : ""}`}>Beranda</button>
                <button onClick={() => setView("mylist")} className={`hover:text-stone-50 transition-colors ${view === "mylist" ? "text-stone-50 font-semibold" : ""}`}>Daftar Saya ({myList.length})</button>
              </nav>
            </div>
            <div className="flex items-center gap-3">
              <div className="hidden sm:flex items-center bg-white/5 rounded-full px-3 py-1.5 ring-1 ring-white/10 focus-within:ring-amber-500/60 transition-shadow">
                <Search size={15} className="text-stone-400 mr-2" />
                <input
                  value={query}
                  onChange={(e) => { setQuery(e.target.value); setView("home"); }}
                  placeholder="Cari judul atau kategori..."
                  className="bg-transparent outline-none text-sm text-stone-200 placeholder:text-stone-500 w-44"
                />
              </div>
              <button className="md:hidden p-2 text-stone-200" onClick={() => setMenuOpen((m) => !m)} aria-label="Menu">
                {menuOpen ? <X size={20} /> : <Menu size={20} />}
              </button>
            </div>
          </div>
          {menuOpen && (
            <div className="md:hidden px-4 pb-4 flex flex-col gap-3 bg-zinc-950/95">
              <div className="flex items-center bg-white/5 rounded-full px-3 py-2 ring-1 ring-white/10">
                <Search size={15} className="text-stone-400 mr-2" />
                <input
                  value={query}
                  onChange={(e) => { setQuery(e.target.value); setView("home"); }}
                  placeholder="Cari judul..."
                  className="bg-transparent outline-none text-sm text-stone-200 placeholder:text-stone-500 flex-1"
                />
              </div>
              <button onClick={() => { setView("home"); setMenuOpen(false); }} className="text-left text-stone-200 py-1">Beranda</button>
              <button onClick={() => { setView("mylist"); setMenuOpen(false); }} className="text-left text-stone-200 py-1">Daftar Saya ({myList.length})</button>
            </div>
          )}
        </div>
      </header>

      {view === "home" && !isFiltering && (
        <section className="relative w-full h-[62vh] sm:h-[68vh] flex items-end">
          <div className={`absolute inset-0 bg-gradient-to-br ${catInfo(spotlight.category).gradient}`} />
          <div className="absolute inset-0 bg-gradient-to-t from-zinc-950 via-zinc-950/40 to-transparent" />
          <div className="absolute inset-0 bg-gradient-to-r from-zinc-950/70 via-transparent to-transparent" />
          <div className="relative z-10 px-4 sm:px-8 pb-10 max-w-lg">
            <span className="text-amber-400 text-xs uppercase tracking-widest font-semibold">Sorotan Minggu Ini</span>
            <h1 className="brand text-4xl sm:text-6xl text-stone-50 mt-2 leading-none">{spotlight.title}</h1>
            <div className="flex items-center gap-3 mt-3 text-sm text-stone-300">
              <span className="flex items-center gap-1 text-amber-400"><Star size={14} fill="currentColor" /> {spotlight.rating}</span>
              <span>{spotlight.year}</span>
              <span className="flex items-center gap-1"><Clock size={14} /> {spotlight.runtime} min</span>
            </div>
            <p className="text-stone-300 text-sm sm:text-base mt-3 leading-relaxed">{spotlight.synopsis}</p>
            <div className="flex items-center gap-3 mt-5">
              <button
                onClick={() => setSelected(spotlight)}
                className="flex items-center gap-2 px-5 py-2.5 rounded bg-amber-500 text-zinc-950 font-semibold text-sm hover:bg-amber-400 transition-colors"
              >
                <Play size={16} fill="currentColor" /> Tonton Pratinjau
              </button>
              <button
                onClick={() => setSelected(spotlight)}
                className="flex items-center gap-2 px-5 py-2.5 rounded bg-white/10 text-stone-100 font-semibold text-sm hover:bg-white/20 transition-colors"
              >
                <Info size={16} /> Info
              </button>
            </div>
          </div>
        </section>
      )}

      <main className={`relative z-10 ${view === "home" && !isFiltering ? "-mt-10" : "pt-28"} pb-16`}>
        {view === "home" && (
          <>
            <div className="px-4 sm:px-8 flex flex-wrap items-center gap-2 mb-6">
              <button
                onClick={() => setActiveCat("all")}
                className={`px-3 py-1.5 rounded-full text-xs font-medium transition-colors ${activeCat === "all" ? "bg-amber-500 text-zinc-950" : "bg-white/5 text-stone-300 hover:bg-white/10"}`}
              >
                Semua
              </button>
              {CATEGORIES.map((c) => (
                <button
                  key={c.id}
                  onClick={() => setActiveCat(c.id)}
                  className={`px-3 py-1.5 rounded-full text-xs font-medium transition-colors ${activeCat === c.id ? "bg-amber-500 text-zinc-950" : "bg-white/5 text-stone-300 hover:bg-white/10"}`}
                >
                  {c.label}
                </button>
              ))}
              <select
                value={sortBy}
                onChange={(e) => setSortBy(e.target.value)}
                className="ml-auto bg-white/5 text-stone-300 text-xs rounded-full px-3 py-1.5 outline-none ring-1 ring-white/10"
              >
                <option value="default">Urutan Default</option>
                <option value="rating-desc">Rating Tertinggi</option>
                <option value="year-desc">Terbaru</option>
                <option value="title-asc">Judul A-Z</option>
              </select>
            </div>

            {isFiltering ? (
              <div className="px-4 sm:px-8">
                <h2 className="text-stone-100 font-semibold mb-4">{filtered.length} hasil ditemukan</h2>
                {filtered.length === 0 ? (
                  <p className="text-stone-500 text-sm">Tidak ada film yang cocok. Coba kata kunci atau filter lain.</p>
                ) : (
                  <div className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-6 gap-3">
                    {filtered.map((m) => (
                      <div key={m.id} className="aspect-[2/3]">
                        <MovieCard movie={m} onOpen={setSelected} inList={myList.includes(m.id)} onToggleList={toggleList} />
                      </div>
                    ))}
                  </div>
                )}
              </div>
            ) : (
              CATEGORIES.map((c) => (
                <MovieRow
                  key={c.id}
                  category={c}
                  movies={MOVIES.filter((m) => m.category === c.id)}
                  onOpen={setSelected}
                  myList={myList}
                  onToggleList={toggleList}
                />
              ))
            )}
          </>
        )}

        {view === "mylist" && (
          <div className="px-4 sm:px-8">
            <h2 className="text-stone-50 brand text-2xl mb-5">Daftar Saya</h2>
            {!listLoaded ? (
              <p className="text-stone-500 text-sm">Memuat daftar...</p>
            ) : myListMovies.length === 0 ? (
              <div className="flex flex-col items-center justify-center text-center py-16 gap-2">
                <Bookmark className="text-stone-600" size={36} />
                <p className="text-stone-400 text-sm max-w-xs">Daftar kamu masih kosong. Tambahkan film dengan menekan tombol + pada poster.</p>
              </div>
            ) : (
              <div className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-6 gap-3">
                {myListMovies.map((m) => (
                  <div key={m.id} className="aspect-[2/3]">
                    <MovieCard movie={m} onOpen={setSelected} inList myList={myList} onToggleList={toggleList} />
                  </div>
                ))}
              </div>
            )}
          </div>
        )}
      </main>

      <footer className="px-4 sm:px-8 py-6 text-center text-stone-600 text-xs border-t border-white/5">
        CineVault — demo antarmuka katalog streaming. Tidak ada konten video berhak cipta yang didistribusikan.
      </footer>

      <MovieModal movie={selected} onClose={() => setSelected(null)} inList={selected ? myList.includes(selected.id) : false} onToggleList={toggleList} />
    </div>
  );
}
