-- phpMyAdmin SQL Dump
-- version 4.9.2
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jan 14, 2025 at 01:01 AM
-- Server version: 10.4.10-MariaDB
-- PHP Version: 7.1.33

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `reservesphp2`
--

-- --------------------------------------------------------

--
-- Table structure for table `ai_responses`
--

CREATE TABLE `ai_responses` (
  `id` int(11) NOT NULL,
  `input_text` text DEFAULT NULL,
  `response_text` text DEFAULT NULL,
  `used_patterns` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`used_patterns`)),
  `confidence_score` float DEFAULT NULL,
  `feedback_score` float DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `articles`
--

CREATE TABLE `articles` (
  `article_id` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `summary` text NOT NULL,
  `content` text NOT NULL,
  `definition` text DEFAULT NULL,
  `etymology` text DEFAULT NULL,
  `usage_examples` text DEFAULT NULL,
  `related_words` text DEFAULT NULL,
  `dictionary_definition` text DEFAULT NULL,
  `wikipedia_excerpt` text DEFAULT NULL,
  `encyclopedia_link` varchar(255) DEFAULT NULL,
  `confidence` float NOT NULL,
  `ai_thoughts` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `status` enum('draft','published','archived') DEFAULT 'draft',
  `view_count` int(11) DEFAULT 0,
  `feedback_count` int(11) DEFAULT 0,
  `last_feedback_at` timestamp NULL DEFAULT NULL,
  `confidence_score` float DEFAULT 1,
  `topic` varchar(50) DEFAULT 'general',
  `user_id` int(11) DEFAULT NULL,
  `tags` text DEFAULT NULL,
  `article_type` enum('standard','term','trending','rss_synthesis') DEFAULT 'standard',
  `source_type` varchar(100) DEFAULT NULL,
  `raw_content` text DEFAULT NULL,
  `external_references` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`external_references`)),
  `complexity_level` varchar(50) DEFAULT NULL,
  `reading_time` int(11) DEFAULT 0,
  `ai_confidence` decimal(5,2) DEFAULT 0.75,
  `wordpedia_link` varchar(255) DEFAULT NULL,
  `type` text NOT NULL,
  `word` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `articles`
--

INSERT INTO `articles` (`article_id`, `title`, `summary`, `content`, `definition`, `etymology`, `usage_examples`, `related_words`, `dictionary_definition`, `wikipedia_excerpt`, `encyclopedia_link`, `confidence`, `ai_thoughts`, `created_at`, `updated_at`, `status`, `view_count`, `feedback_count`, `last_feedback_at`, `confidence_score`, `topic`, `user_id`, `tags`, `article_type`, `source_type`, `raw_content`, `external_references`, `complexity_level`, `reading_time`, `ai_confidence`, `wordpedia_link`, `type`, `word`) VALUES
(106, 'Helmsburg', 'Helmsburg', '<iframe height=\"600px\" width=\"100%\" src=\"http://localhost/wordpedia/pages/Helmsburg\"></iframe>', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0.7264, NULL, '2025-01-13 09:54:54', '2025-01-13 09:54:54', 'draft', 0, 0, NULL, 1, 'general', NULL, '[]', 'standard', NULL, NULL, NULL, NULL, 0, '0.75', NULL, 'term', ''),
(107, 'God', 'God', '<iframe height=\"600px\" width=\"100%\" src=\"http://localhost/wordpedia/pages/god\"></iframe>', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0.7264, NULL, '2025-01-13 09:55:01', '2025-01-13 09:55:01', 'draft', 0, 0, NULL, 1, 'general', NULL, '[]', 'standard', NULL, NULL, NULL, NULL, 0, '0.75', NULL, 'term', ''),
(108, 'Trending Now: Abstract and Related Topics', 'Trending Now: Abstract and Related Topics', '<h1>Trending Now: Abstract and Related Topics</h1><p><strong>Key Trend:</strong> Abstract (Mentioned 139 times)</p><p><strong>Definition:</strong> 1. Withdraw; separate. [Obs.] The more abstract . . . we are from the body. Norris. 2. Considered apart from any application to a particular object; separated from matter; exiting in the mind only; as, abstract truth, abstract numbers. Hence: ideal; abstruse; difficult. 3. (Logic) (a) Expressing a particular property of an object viewed apart from the other properties which constitute it; -- opposed to Ant: concrete; as, honesty is an abstract word. J. S. Mill. (b) Resulting from the mental faculty of abstraction; general as opposed to particular; as, \"reptile\" is an abstract or general name. Locke. A concrete name is a name which stands for a thing; an abstract name which stands for an attribute of a thing. A practice has grown up in more modern times, which, if not introduced by Locke, has gained currency from his example, of applying the expression \"abstract name\" to all names which are the result of abstraction and generalization, and consequently to all general names, instead of confining it to the names of attributes. J. S. Mill. 4. Abstracted; absent in mind. \"Abstract, as in a trance.\" Milton. An abstract idea (Metaph.), an idea separated from a complex object, or from other ideas which naturally accompany it; as the solidity of marble when contemplated apart from its color or figure. -- Abstract terms, those which express abstract ideas, as beauty, whiteness, roundness, without regarding any object in which they exist; or abstract terms are the names of orders, genera or species of things, in which there is a combination of similar qualities. -- Abstract numbers (Math.), numbers used without application to things, as 6, 8, 10; but when applied to any thing, as 6 feet, 10 men, they become concrete. -- Abstract or Pure mathematics. See Mathematics.\n\n1. To withdraw; to separate; to take away. He was incapable of forming any opinion or resolution abstracted from his own prejudices. Sir W. Scott. 2. To draw off in respect to interest or attention; as, his was wholly abstracted by other objects. The young stranger had been abstracted and silent. Blackw. Mag. 3. To separate, as ideas, by the operation of the mind; to consider by itself; to contemplate separately, as a quality or attribute. Whately. 4. To epitomize; to abridge. Franklin. 5. To take secretly or dishonestly; to purloin; as, to abstract goods from a parcel, or money from a till. Von Rosen had quietly abstracted the bearing-reins from the harness. W. Black. 6. (Chem.)  To separate, as the more volatile or soluble parts of a substance, by distillation or other chemical processes. In this sense extract is now more generally used.\n\nTo perform the process of abstraction. [R.] I own myself able to abstract in one sense. Berkeley.\n\n1. That which comprises or concentrates in itself the essential qualities of a larger thing or of several things. Specifically: A summary or an epitome, as of a treatise or book, or of a statement; a brief. An abstract of every treatise he had read. Watts. Man,</p><h2>Current Trends Analysis</h2><p>In the rapidly evolving landscape of 139, 136, 135, we are witnessing unprecedented developments.\n\n</p><h2>Related Trending Topics (Names, Places, Ideas, or Things)</h2><ul><li>Announce (Mentioned 136 times) <br><small>A comprehensive exploration of the term \'Announce\' and its significance in modern context.</small></li><li>Arxiv (Mentioned 135 times) <br><small>A comprehensive exploration of the term \'Arxiv\' and its significance in modern context.</small></li><li>Language (Mentioned 113 times) <br><small>A comprehensive exploration of the term \'Language\' and its significance in modern context.</small></li><li>Learning (Mentioned 110 times) <br><small>A comprehensive exploration of the term \'Learning\' and its significance in modern context.</small></li><li>Training (Mentioned 72 times) <br><small>A comprehensive exploration of the term \'Training\' and its significance in modern context.</small></li></ul><p>This trend analysis is based on recent RSS feeds from various news sources, focusing on names, places, ideas, or things with 5 or more letters.</p>', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0.88, NULL, '2025-01-13 09:57:03', '2025-01-13 09:57:03', 'draft', 0, 0, NULL, 1, 'general', NULL, '{\"abstract\":139,\"announce\":136,\"arxiv\":135,\"language\":113,\"learning\":110,\"training\":72,\"china\":66,\"using\":63,\"trump\":63,\"human\":60}', 'standard', NULL, NULL, NULL, NULL, 0, '0.75', NULL, 'trending', ''),
(109, 'Latest Insights: World_news', 'Latest Insights: World_news', 'Dollar hits two-year high after robust US data puts brake on rate cut bets. Pound drops to 14-month low and gilts weaken as investors continue to shun UK assets How El Salvador became a model for the global far right. President Nayib Bukele has brought stability and safety, but imprisoned tens of thousands. Governments face dilemmas about how to engage The cravenness of Mark Zuckerberg . Changes to the fact-checking regime at Meta make it look like he’s caving in to Trump Where voters don’t want to throw the incumbents out — and why. The global rebellion against those in power does not extend to the developing world California fires could be costliest disaster in US history, says governor. Gavin Newsom accuses Trump of spreading disinformation after president-elect calls emergency response ‘incompetent’ Asset managers turn to defensive positioning as equity prices soar . Elevated level of stocks and prospect of higher for longer rates have some firms sending up caution flares China corporate profits set for third year of declines. Oversupply drives intense competition that is undermining prices and profitability China’s trade surplus hits annual record of nearly $1tn. Rise in exports comes days ahead of Donald Trump’s inauguration Debts on EY’s failed Project Everest took longer than expected to clear.', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0.7772, NULL, '2025-01-13 09:58:17', '2025-01-13 09:58:17', 'draft', 0, 0, NULL, 1, 'general', NULL, '[]', 'standard', NULL, NULL, NULL, NULL, 0, '0.75', NULL, 'rss_synthesis', ''),
(110, 'Latest Insights: World_news', 'Latest Insights: World_news', 'Dollar hits two-year high after robust US data puts brake on rate cut bets. Euro approaches parity with US currency and pound drops to 14-month low ECB’s chief economist warns of too-low inflation if rates stay high. Philip Lane points to dangers of borrowing costs that remain ‘too high for too long’ How El Salvador became a model for the global far right. President Nayib Bukele has brought stability and safety, but imprisoned tens of thousands. Governments face dilemmas about how to engage Trump risks turning the US into a rogue state. Territorial expansionism and threats to neighbours and allies should set off alarm bells across the world The cravenness of Mark Zuckerberg . Changes to the fact-checking regime at Meta make it look like he’s caving in to Trump Big US banks set for $31bn quarterly profit as Wall Street business booms. Trading activity boosted in final quarter of 2024 by Donald Trump’s election win Asset managers turn to defensive positioning as equity prices soar . Elevated level of stocks and prospect of higher for longer rates have some firms sending up caution flares China building new mobile piers that could help possible Taiwan invasion. Satellite images reveal barge-like vessels that could help transport tanks and artillery over coastal mudflats Syria flooded with Pepsi and Pringles as rulers open economy.', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0.7788, NULL, '2025-01-13 12:28:32', '2025-01-13 12:28:32', 'draft', 0, 0, NULL, 1, 'general', NULL, '[]', 'standard', NULL, NULL, NULL, NULL, 0, '0.75', NULL, 'rss_synthesis', ''),
(111, 'Latest Insights: Technology', 'Latest Insights: Technology', 'The Hidden Risks of URL-Shortening in Scientific Review. Reviewers, authors, and editors all have a role to play in protecting fairness and objectivity in the blind review process. Assessment in Computer Science Education in the GenAI Era. Exploring the need to rethink assessment in computer science education in the Generative AI era. We’re Reaping Just What We Sowed. The idea of computing using an abstract machine model that can grow during the execution of an algorithm leads to a theory of computation that is quite rich. How Software Bugs led to ‘One of the Greatest Miscarriages of Justice’ in British History. Bad coding and bad testing characterize the software that led to wrongful convictions, financial ruin, and four suicides. Justice, Equity, Diversity, and Inclusion at UbiComp/ISWC: Best Practices for Accessible and Equitable Computing Conferences. Initiatives created for the 2023 UbiComp/ISWC conference illustrate what can and should be done to support the needs of a diverse, increasingly global computing community.', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0.7484, NULL, '2025-01-13 12:29:32', '2025-01-13 12:29:32', 'draft', 0, 0, NULL, 1, 'general', NULL, '[]', 'standard', NULL, NULL, NULL, NULL, 0, '0.75', NULL, 'rss_synthesis', ''),
(112, 'Latest Insights: Finance', 'Latest Insights: Finance', 'Why global bond markets are convulsing. Pity anyone taking out a mortgage The Los Angeles fires will be extraordinarily expensive. They will also expose California’s faulty insurance market Europe could be torn apart by new divisions. The continent is at its most vulnerable in decades How corporate bonds fell out of fashion. The market is at its hottest in years—and a shadow of its former self An American purchase of Greenland could be the deal of the century. The economics of buying new territory China’s markets take a fresh beating. Authorities have responded by bossing around investors Can America’s economy cope with mass deportations?. Production slowdowns, more imports and pricier housing could follow Would an artificial-intelligence bubble be so bad?. A new book by Byrne Hobart and Tobias Huber argues there are advantages to financial mania Will Elon Musk dominate President Trump’s economic policy?. He will face challenges from both America firsters and conservative mainstreamers What investors expect from President Trump.', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0.748, NULL, '2025-01-13 12:36:51', '2025-01-13 12:36:51', 'draft', 0, 0, NULL, 1, 'general', NULL, '[]', 'standard', NULL, NULL, NULL, NULL, 0, '0.75', NULL, 'rss_synthesis', ''),
(113, 'Trending Now: Abstract and Related Topics', 'Trending Now: Abstract and Related Topics', '<h1>Trending Now: Abstract and Related Topics</h1><p><strong>Key Trend:</strong> Abstract (Mentioned 139 times)</p><p><strong>Definition:</strong> 1. Withdraw; separate. [Obs.] The more abstract . . . we are from the body. Norris. 2. Considered apart from any application to a particular object; separated from matter; exiting in the mind only; as, abstract truth, abstract numbers. Hence: ideal; abstruse; difficult. 3. (Logic) (a) Expressing a particular property of an object viewed apart from the other properties which constitute it; -- opposed to Ant: concrete; as, honesty is an abstract word. J. S. Mill. (b) Resulting from the mental faculty of abstraction; general as opposed to particular; as, \"reptile\" is an abstract or general name. Locke. A concrete name is a name which stands for a thing; an abstract name which stands for an attribute of a thing. A practice has grown up in more modern times, which, if not introduced by Locke, has gained currency from his example, of applying the expression \"abstract name\" to all names which are the result of abstraction and generalization, and consequently to all general names, instead of confining it to the names of attributes. J. S. Mill. 4. Abstracted; absent in mind. \"Abstract, as in a trance.\" Milton. An abstract idea (Metaph.), an idea separated from a complex object, or from other ideas which naturally accompany it; as the solidity of marble when contemplated apart from its color or figure. -- Abstract terms, those which express abstract ideas, as beauty, whiteness, roundness, without regarding any object in which they exist; or abstract terms are the names of orders, genera or species of things, in which there is a combination of similar qualities. -- Abstract numbers (Math.), numbers used without application to things, as 6, 8, 10; but when applied to any thing, as 6 feet, 10 men, they become concrete. -- Abstract or Pure mathematics. See Mathematics.\n\n1. To withdraw; to separate; to take away. He was incapable of forming any opinion or resolution abstracted from his own prejudices. Sir W. Scott. 2. To draw off in respect to interest or attention; as, his was wholly abstracted by other objects. The young stranger had been abstracted and silent. Blackw. Mag. 3. To separate, as ideas, by the operation of the mind; to consider by itself; to contemplate separately, as a quality or attribute. Whately. 4. To epitomize; to abridge. Franklin. 5. To take secretly or dishonestly; to purloin; as, to abstract goods from a parcel, or money from a till. Von Rosen had quietly abstracted the bearing-reins from the harness. W. Black. 6. (Chem.)  To separate, as the more volatile or soluble parts of a substance, by distillation or other chemical processes. In this sense extract is now more generally used.\n\nTo perform the process of abstraction. [R.] I own myself able to abstract in one sense. Berkeley.\n\n1. That which comprises or concentrates in itself the essential qualities of a larger thing or of several things. Specifically: A summary or an epitome, as of a treatise or book, or of a statement; a brief. An abstract of every treatise he had read. Watts. Man,</p><h2>Current Trends Analysis</h2><p>In the rapidly evolving landscape of 139, 136, 135, we are witnessing unprecedented developments.\n\n</p><h2>Related Trending Topics (Names, Places, Ideas, or Things)</h2><ul><li>Announce (Mentioned 136 times) <br><small>A comprehensive exploration of the term \'Announce\' and its significance in modern context.</small></li><li>Arxiv (Mentioned 135 times) <br><small>A comprehensive exploration of the term \'Arxiv\' and its significance in modern context.</small></li><li>Language (Mentioned 113 times) <br><small>A comprehensive exploration of the term \'Language\' and its significance in modern context.</small></li><li>Learning (Mentioned 111 times) <br><small>A comprehensive exploration of the term \'Learning\' and its significance in modern context.</small></li><li>China (Mentioned 107 times) <br><small>A comprehensive exploration of the term \'China\' and its significance in modern context.</small></li></ul><p>This trend analysis is based on recent RSS feeds from various news sources, focusing on names, places, ideas, or things with 5 or more letters.</p>', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0.88, NULL, '2025-01-13 12:44:09', '2025-01-13 12:44:09', 'draft', 0, 0, NULL, 1, 'general', NULL, '{\"abstract\":139,\"announce\":136,\"arxiv\":135,\"language\":113,\"learning\":111,\"china\":107,\"trump\":88,\"training\":72,\"america\":70,\"using\":63}', 'standard', NULL, NULL, NULL, NULL, 0, '0.75', NULL, 'trending', ''),
(114, 'Latest Insights: Environment', 'Latest Insights: Environment', 'Experts meet in Malaysia to scope three Working Group contributions to the IPCC Seventh Assessment Report. More than 230 experts from over 70 countries will gather at the Scoping Meeting in Kuala Lumpur, Malaysia from 9 to 13 December to draft the outlines of the three Working Group contributions to the Seventh Assessment Report (AR7) of the Intergovernmental Panel on Climate Change (IPCC). Working Group contributions are the three key pillars [&#8230;] IPCC announcement. Upon the invitation of the International Court of Justice (ICJ), a group of past and present scientists of the Intergovernmental Panel on Climate Change (IPCC) is meeting ICJ judges in The Hague on 26 November to enhance the Court’s understanding of the key scientific findings which the IPCC has delivered through its periodic assessment reports [&#8230;] IPCC Chair’s remarks at the High-Level Ministerial Roundtable on Pre-2030 Ambition. COP29, Baku, Azerbaijan, 18 November 2024 CHECK AGAINST DELIVERY Yours excellencies, distinguished delegates, ladies and gentleman, it is my privilege as Chair of the Intergovernmental Panel on Climate Change – the IPCC – to address this important session. I recall participating in the same session at COP 27, and I very much appreciate this further [&#8230;] IPCC Chair’s remarks during the opening of the High-Level Segment of the World Leaders Climate Action Summit. Baku, Azerbaijan 12 November 2024 Your Excellencies, Dear delegates, Ladies and Gentlemen As the Chair of the Intergovernmental Panel on Climate Change – the IPCC – it is an honour to address the High-Level Segment of COP 29. Climate change is no longer an abstract threat for a distant future. It has been unfolding in [&#8230;] IPCC Chair’s remarks during the opening of the Earth Information Day event at COP29. 11 November 2024, Baku, Azerbaijan Check against delivery.', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0.7884, NULL, '2025-01-13 12:45:47', '2025-01-13 12:45:47', 'draft', 0, 0, NULL, 1, 'general', NULL, '[]', 'standard', NULL, NULL, NULL, NULL, 0, '0.75', NULL, 'rss_synthesis', '');

-- --------------------------------------------------------

--
-- Table structure for table `article_edits`
--

CREATE TABLE `article_edits` (
  `edit_id` int(11) NOT NULL,
  `article_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `previous_title` text DEFAULT NULL,
  `previous_summary` text DEFAULT NULL,
  `new_title` text DEFAULT NULL,
  `new_summary` text DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `status` enum('pending','approved','rejected') DEFAULT 'pending',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `reviewed_at` timestamp NULL DEFAULT NULL,
  `reviewer_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `article_edits`
--

INSERT INTO `article_edits` (`edit_id`, `article_id`, `user_id`, `previous_title`, `previous_summary`, `new_title`, `new_summary`, `notes`, `status`, `created_at`, `reviewed_at`, `reviewer_id`) VALUES
(1, 1, 1, 'AI Makes Breakthrough in Renewable Energy', 'Recent developments show promising results...', 'AI Makes Breakthrough in Renewable Energy', 'Recent developments show promising results...', '', 'pending', '2025-01-11 00:59:41', NULL, NULL),
(2, 1, 1, NULL, NULL, NULL, NULL, 'wrote hi lol', 'pending', '2025-01-11 02:13:17', NULL, NULL),
(3, 68, 1, NULL, NULL, NULL, NULL, '', 'pending', '2025-01-11 21:45:25', NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `article_feedback`
--

CREATE TABLE `article_feedback` (
  `feedback_id` int(11) NOT NULL,
  `article_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `feedback_type` enum('accurate','inaccurate','grammar','factual','clarity','style') DEFAULT NULL,
  `feedback_weight` float DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `article_feedback`
--

INSERT INTO `article_feedback` (`feedback_id`, `article_id`, `user_id`, `feedback_type`, `feedback_weight`, `notes`, `created_at`) VALUES
(1, 2, 1, 'accurate', NULL, NULL, '2025-01-11 04:11:20'),
(2, 1, 1, 'accurate', NULL, NULL, '2025-01-11 04:34:51'),
(3, 2, 1, 'accurate', NULL, NULL, '2025-01-11 04:48:06'),
(4, 2, 1, 'accurate', NULL, NULL, '2025-01-11 04:56:18'),
(5, 2, 1, 'accurate', NULL, NULL, '2025-01-11 04:56:18'),
(6, 2, 1, 'accurate', NULL, NULL, '2025-01-11 05:06:56'),
(7, 3, 1, 'accurate', NULL, NULL, '2025-01-11 05:49:58'),
(8, 41, 1, 'inaccurate', NULL, NULL, '2025-01-11 11:33:26'),
(9, 34, 1, 'accurate', NULL, NULL, '2025-01-11 11:51:24'),
(10, 69, 1, 'accurate', NULL, NULL, '2025-01-11 21:56:35'),
(11, 69, 1, 'accurate', NULL, NULL, '2025-01-11 22:11:34'),
(12, 70, 1, 'accurate', NULL, NULL, '2025-01-11 22:35:42'),
(13, 72, 1, 'accurate', NULL, NULL, '2025-01-11 23:20:17'),
(14, 70, 6, 'accurate', NULL, NULL, '2025-01-12 01:32:05'),
(15, 75, 6, 'accurate', NULL, NULL, '2025-01-12 10:26:11'),
(16, 80, 6, 'accurate', NULL, NULL, '2025-01-13 03:14:27'),
(17, 68, 6, 'accurate', NULL, NULL, '2025-01-13 07:34:48');

-- --------------------------------------------------------

--
-- Table structure for table `article_interactions`
--

CREATE TABLE `article_interactions` (
  `interaction_id` int(11) NOT NULL,
  `article_id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `interaction_type` enum('view','like','dislike','share','comment') NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `article_tags`
--

CREATE TABLE `article_tags` (
  `tag_id` int(11) NOT NULL,
  `article_id` int(11) NOT NULL,
  `tag_name` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `article_topics`
--

CREATE TABLE `article_topics` (
  `article_id` int(11) NOT NULL,
  `topic_id` int(11) NOT NULL,
  `confidence` float DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `article_variations`
--

CREATE TABLE `article_variations` (
  `variation_id` int(11) NOT NULL,
  `parent_article_id` int(11) DEFAULT NULL,
  `variation_type` enum('summary','detailed','alternative_perspective') NOT NULL,
  `content` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `chat_responses`
--

CREATE TABLE `chat_responses` (
  `response_id` int(11) NOT NULL,
  `input_text` text DEFAULT NULL,
  `response_text` text DEFAULT NULL,
  `sensory_context_id` int(11) DEFAULT NULL,
  `environmental_factors` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`environmental_factors`)),
  `confidence_score` float DEFAULT NULL,
  `effectiveness_rating` float DEFAULT NULL,
  `timestamp` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `comments`
--

CREATE TABLE `comments` (
  `comment_id` int(11) NOT NULL,
  `article_id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `content` text NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `votes` int(11) DEFAULT 0,
  `email` varchar(130) NOT NULL,
  `username` varchar(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `comments`
--

INSERT INTO `comments` (`comment_id`, `article_id`, `user_id`, `content`, `created_at`, `votes`, `email`, `username`) VALUES
(7, 1, 1, 'Fascinating article about AI developments!', '2025-01-11 02:51:26', 1, '', ''),
(8, 1, NULL, 'Great insights into machine learning.', '2025-01-11 02:51:26', 0, '', ''),
(9, 1, 1, 'This technology seems promising.', '2025-01-11 02:51:26', -1, '', ''),
(10, 2, 2, 'hello', '2025-01-11 05:40:42', 1, '', ''),
(11, 1, NULL, 'hi', '2025-01-11 12:12:25', 1, '', 'Vikerus'),
(12, 40, NULL, 'thanks', '2025-01-11 12:13:10', 1, '', 'Vikerus'),
(13, 55, NULL, 'Hello', '2025-01-11 13:21:36', 2, '', 'Vikerus'),
(15, 74, NULL, 'love', '2025-01-12 01:56:17', 1, '', 'Vikerus');

-- --------------------------------------------------------

--
-- Table structure for table `contextual_states`
--

CREATE TABLE `contextual_states` (
  `state_id` int(11) NOT NULL,
  `environment_state` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`environment_state`)),
  `mood_indicators` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`mood_indicators`)),
  `active_participants` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`active_participants`)),
  `sensory_summary` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`sensory_summary`)),
  `timestamp` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `corrections`
--

CREATE TABLE `corrections` (
  `correction_id` int(11) NOT NULL,
  `article_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `correction_text` text NOT NULL,
  `status` enum('pending','approved','rejected') DEFAULT 'pending',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `feedback`
--

CREATE TABLE `feedback` (
  `feedback_id` int(11) NOT NULL,
  `article_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `feedback_type` enum('upvote','downvote','report') NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `feedback`
--

INSERT INTO `feedback` (`feedback_id`, `article_id`, `user_id`, `feedback_type`, `created_at`) VALUES
(1, 1, NULL, '', '2025-01-10 17:27:56'),
(2, 1, NULL, '', '2025-01-11 01:00:02');

-- --------------------------------------------------------

--
-- Table structure for table `learning_patterns`
--

CREATE TABLE `learning_patterns` (
  `id` int(11) NOT NULL,
  `pattern_type` varchar(50) DEFAULT NULL,
  `pattern_data` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`pattern_data`)),
  `success_rate` float DEFAULT 1,
  `usage_count` int(11) DEFAULT 1,
  `last_used` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `multiplayer_states`
--

CREATE TABLE `multiplayer_states` (
  `state_id` int(11) NOT NULL,
  `room_id` varchar(50) DEFAULT NULL,
  `participant_states` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`participant_states`)),
  `environmental_data` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`environmental_data`)),
  `sensory_influence` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`sensory_influence`)),
  `last_update` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `active_status` tinyint(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `sensory_data`
--

CREATE TABLE `sensory_data` (
  `data_id` int(11) NOT NULL,
  `data_type` enum('video','audio','motion','combined') DEFAULT NULL,
  `raw_data` longblob DEFAULT NULL,
  `processed_features` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`processed_features`)),
  `context_data` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`context_data`)),
  `influence_score` float DEFAULT NULL,
  `timestamp` timestamp NOT NULL DEFAULT current_timestamp(),
  `last_used` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `sensory_influences`
--

CREATE TABLE `sensory_influences` (
  `influence_id` int(11) NOT NULL,
  `sensory_data_id` int(11) DEFAULT NULL,
  `target_type` enum('chat','multiplayer','personality') DEFAULT NULL,
  `influence_type` varchar(50) DEFAULT NULL,
  `influence_strength` float DEFAULT NULL,
  `applied_timestamp` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `sensory_inputs`
--

CREATE TABLE `sensory_inputs` (
  `id` int(11) NOT NULL,
  `input_type` enum('audio','video','motion') DEFAULT NULL,
  `raw_data` longblob DEFAULT NULL,
  `processed_data` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`processed_data`)),
  `context_info` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`context_info`)),
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `sensory_inputs`
--

INSERT INTO `sensory_inputs` (`id`, `input_type`, `raw_data`, `processed_data`, `context_info`, `created_at`) VALUES
(1, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:21:34'),
(2, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:21:34'),
(3, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:21:34'),
(4, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:21:34'),
(5, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:21:34'),
(6, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:21:34'),
(7, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:21:34'),
(8, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:21:35'),
(9, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:21:35'),
(10, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:21:35'),
(11, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:21:35'),
(12, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:21:35'),
(13, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:21:35'),
(14, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:21:35'),
(15, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:21:35'),
(16, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:21:36'),
(17, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:21:36'),
(18, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:21:36'),
(19, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:21:36'),
(20, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:21:36'),
(21, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:21:36'),
(22, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:21:36'),
(23, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:21:36'),
(24, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:21:37'),
(25, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:21:37'),
(26, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:21:37'),
(27, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:21:37'),
(28, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:21:37'),
(29, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:21:37'),
(30, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:21:37'),
(31, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:21:38'),
(32, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:21:38'),
(33, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:21:38'),
(34, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:21:38'),
(35, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:21:38'),
(36, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:21:38'),
(37, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:21:39'),
(38, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:21:39'),
(39, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:21:39'),
(40, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:21:39'),
(41, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:21:39'),
(42, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:21:39'),
(43, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:21:39'),
(44, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:21:40'),
(45, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:21:40'),
(46, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:21:40'),
(47, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:21:40'),
(48, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:21:40'),
(49, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:21:40'),
(50, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:21:40'),
(51, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:21:41'),
(52, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:21:41'),
(53, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:21:41'),
(54, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:21:41'),
(55, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:21:41'),
(56, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:21:41'),
(57, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:21:41'),
(58, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:21:42'),
(59, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:21:42'),
(60, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:21:42'),
(61, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:21:42'),
(62, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:21:42'),
(63, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:21:42'),
(64, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:21:42'),
(65, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:21:42'),
(66, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:21:43'),
(67, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:21:43'),
(68, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:21:43'),
(69, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:21:43'),
(70, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:21:43'),
(71, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:21:43'),
(72, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:21:43'),
(73, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:21:44'),
(74, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:21:44'),
(75, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:21:44'),
(76, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:21:44'),
(77, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:21:44'),
(78, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:21:44'),
(79, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:21:44'),
(80, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:21:44'),
(81, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:21:45'),
(82, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:21:45'),
(83, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:21:45'),
(84, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:21:45'),
(85, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:21:45'),
(86, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:21:45'),
(87, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:21:45'),
(88, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:21:46'),
(89, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:21:46'),
(90, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:21:46'),
(91, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:21:46'),
(92, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:21:46'),
(93, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:21:46'),
(94, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:21:46'),
(95, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:21:46'),
(96, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:21:47'),
(97, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:21:47'),
(98, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:21:47'),
(99, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:21:48'),
(100, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:21:49'),
(101, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:21:51'),
(102, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:21:55'),
(103, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:22:03'),
(104, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:22:06'),
(105, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:22:07'),
(106, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:22:08'),
(107, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:22:09'),
(108, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:22:11'),
(109, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:22:15'),
(110, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:22:19'),
(111, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:22:19'),
(112, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:22:19'),
(113, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:22:19'),
(114, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:22:19'),
(115, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:22:20'),
(116, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:22:20'),
(117, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:22:20'),
(118, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:22:20'),
(119, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:22:20'),
(120, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:22:20'),
(121, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:22:21'),
(122, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:22:21'),
(123, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:22:21'),
(124, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:22:21'),
(125, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:22:21'),
(126, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:22:21'),
(127, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:22:22'),
(128, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:22:22'),
(129, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:22:22'),
(130, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:22:22'),
(131, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:22:22'),
(132, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:22:22'),
(133, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:22:22'),
(134, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:22:23'),
(135, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:22:23'),
(136, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:22:23'),
(137, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:22:23'),
(138, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:22:23'),
(139, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:22:23'),
(140, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:22:23'),
(141, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:22:23'),
(142, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:22:23'),
(143, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:22:24'),
(144, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:22:24'),
(145, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:22:24'),
(146, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:22:24'),
(147, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:22:24'),
(148, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:22:24'),
(149, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:22:24'),
(150, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:22:24'),
(151, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:22:24'),
(152, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:22:25'),
(153, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:22:25'),
(154, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:22:25'),
(155, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:22:25'),
(156, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:22:26'),
(157, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:22:27'),
(158, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:22:27'),
(159, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:22:29'),
(160, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:22:31'),
(161, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:22:33'),
(162, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:22:39'),
(163, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:22:41'),
(164, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:22:55'),
(165, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:22:57'),
(166, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:22:59'),
(167, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:23:03'),
(168, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:23:11'),
(169, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:23:27'),
(170, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:23:28'),
(171, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:23:59'),
(172, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:24:32'),
(173, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:25:03'),
(174, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:25:15'),
(175, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:25:16'),
(176, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:25:16'),
(177, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:25:16'),
(178, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:25:16'),
(179, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:25:16'),
(180, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:25:17'),
(181, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:25:17'),
(182, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:25:17'),
(183, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:25:17'),
(184, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:25:17'),
(185, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:25:17'),
(186, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:25:17'),
(187, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:25:18'),
(188, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:25:18'),
(189, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:25:18'),
(190, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:25:18'),
(191, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:25:18'),
(192, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:25:18'),
(193, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:25:18'),
(194, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:25:18'),
(195, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:25:18'),
(196, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:25:19'),
(197, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:25:19'),
(198, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:25:19'),
(199, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:25:19'),
(200, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:25:19'),
(201, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:25:19'),
(202, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:25:19'),
(203, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:25:19'),
(204, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:25:20'),
(205, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:25:20'),
(206, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:25:20'),
(207, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:25:20'),
(208, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:25:20'),
(209, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:25:20'),
(210, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:25:20'),
(211, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:25:20'),
(212, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:25:20'),
(213, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:25:21'),
(214, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:25:21'),
(215, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:25:21'),
(216, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:25:21'),
(217, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:25:21'),
(218, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:25:21'),
(219, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:25:21'),
(220, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:25:21'),
(221, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:25:22'),
(222, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:25:22'),
(223, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:25:22'),
(224, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:25:22'),
(225, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:25:22'),
(226, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:25:22'),
(227, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:25:22'),
(228, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:25:22'),
(229, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:25:23'),
(230, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:25:23'),
(231, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:25:23'),
(232, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:25:23'),
(233, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:25:23'),
(234, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:25:23'),
(235, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:25:23'),
(236, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:25:26'),
(237, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:25:30'),
(238, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:25:38'),
(239, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:25:52'),
(240, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:25:52'),
(241, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:25:52'),
(242, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:25:53'),
(243, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:25:53'),
(244, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:25:53'),
(245, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:25:53'),
(246, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:25:53'),
(247, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:25:54'),
(248, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:25:54'),
(249, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:25:54'),
(250, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:25:54'),
(251, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:25:54'),
(252, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:25:54'),
(253, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:25:54'),
(254, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:25:55'),
(255, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:25:55'),
(256, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:25:55'),
(257, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:25:55'),
(258, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:25:55'),
(259, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:25:55'),
(260, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:25:55'),
(261, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:25:55'),
(262, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:25:56'),
(263, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:25:56'),
(264, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:25:56'),
(265, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:25:56'),
(266, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:25:56'),
(267, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:25:56'),
(268, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:25:56'),
(269, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:25:56'),
(270, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:25:57'),
(271, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:25:57'),
(272, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:25:57'),
(273, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:25:57'),
(274, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:25:57'),
(275, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:25:57'),
(276, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:25:57'),
(277, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:25:57'),
(278, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:25:58'),
(279, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:25:58'),
(280, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:25:58'),
(281, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:25:58'),
(282, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:25:58'),
(283, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:25:58'),
(284, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:25:58'),
(285, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:25:58'),
(286, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:25:58'),
(287, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:25:59'),
(288, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:25:59'),
(289, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:25:59'),
(290, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:25:59'),
(291, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:25:59'),
(292, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:25:59'),
(293, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:25:59'),
(294, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:26:00'),
(295, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:26:00'),
(296, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:26:00'),
(297, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:26:00'),
(298, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:26:00'),
(299, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:26:00'),
(300, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:26:00'),
(301, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:26:00'),
(302, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:26:00'),
(303, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:26:01'),
(304, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:26:01'),
(305, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:26:01'),
(306, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:26:02'),
(307, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:26:03'),
(308, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:26:05'),
(309, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:26:09'),
(310, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:26:17'),
(311, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:26:26'),
(312, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:26:33'),
(313, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:27:00'),
(314, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:27:02'),
(315, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:27:06'),
(316, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:27:14'),
(317, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:27:30'),
(318, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:27:30'),
(319, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:27:34'),
(320, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:27:36'),
(321, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:27:40'),
(322, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:27:48'),
(323, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:27:50'),
(324, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:27:54'),
(325, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:28:02'),
(326, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:28:18'),
(327, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:28:20'),
(328, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:28:25'),
(329, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:28:33'),
(330, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:28:40'),
(331, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:28:42'),
(332, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:28:46'),
(333, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:28:55'),
(334, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:29:11'),
(335, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:29:24'),
(336, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:29:24'),
(337, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:29:24'),
(338, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:29:25'),
(339, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:29:25'),
(340, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:29:25'),
(341, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:29:25'),
(342, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:29:25'),
(343, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:29:25'),
(344, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:29:25'),
(345, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:29:25'),
(346, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:29:26'),
(347, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:29:26'),
(348, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:29:26'),
(349, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:29:26'),
(350, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:29:26'),
(351, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:29:26'),
(352, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:29:27'),
(353, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:29:27'),
(354, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:29:27'),
(355, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:29:27'),
(356, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:29:27'),
(357, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:29:27'),
(358, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:29:27'),
(359, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:29:27'),
(360, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:29:27'),
(361, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:29:28'),
(362, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:29:28'),
(363, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:29:28'),
(364, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:29:28'),
(365, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:29:28'),
(366, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:29:28'),
(367, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:29:28'),
(368, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:29:29'),
(369, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:29:29'),
(370, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:29:29'),
(371, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:29:29'),
(372, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:29:29'),
(373, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:29:29'),
(374, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:29:29'),
(375, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:29:30'),
(376, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:29:30'),
(377, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:29:30'),
(378, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:29:30'),
(379, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:29:30'),
(380, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:29:30'),
(381, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:29:30'),
(382, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:29:30'),
(383, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:29:31'),
(384, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:29:31'),
(385, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:29:31'),
(386, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:29:31'),
(387, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:29:31'),
(388, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:29:31'),
(389, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:29:31'),
(390, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:29:32'),
(391, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:29:32'),
(392, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:29:32'),
(393, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:29:32'),
(394, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:29:32'),
(395, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:29:32'),
(396, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:29:32'),
(397, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:29:33'),
(398, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:29:33'),
(399, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:29:40'),
(400, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:29:42'),
(401, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:29:46'),
(402, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:29:54'),
(403, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:30:04'),
(404, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:30:06'),
(405, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:30:11'),
(406, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:30:19'),
(407, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:30:35'),
(408, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:31:07'),
(409, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:31:13'),
(410, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:31:13'),
(411, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:31:13'),
(412, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:31:13'),
(413, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:31:13'),
(414, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:31:13'),
(415, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:31:14'),
(416, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:31:14'),
(417, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:31:14'),
(418, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:31:14'),
(419, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:31:14'),
(420, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:31:14'),
(421, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:31:14'),
(422, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:31:14'),
(423, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:31:15'),
(424, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:31:15'),
(425, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:31:15'),
(426, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:31:15'),
(427, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:31:15'),
(428, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:31:15'),
(429, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:31:15'),
(430, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:31:15'),
(431, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:31:15'),
(432, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:31:16'),
(433, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:31:16'),
(434, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:31:16'),
(435, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:31:17'),
(436, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:31:18'),
(437, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:31:20'),
(438, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:31:24'),
(439, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:31:32'),
(440, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:31:33'),
(441, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:31:34'),
(442, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:31:35'),
(443, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:31:36'),
(444, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:31:37'),
(445, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:31:39'),
(446, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:31:43'),
(447, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:31:51'),
(448, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:32:02'),
(449, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:32:05'),
(450, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:32:09'),
(451, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:32:17'),
(452, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:32:29'),
(453, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:32:31'),
(454, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:32:35'),
(455, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:32:43'),
(456, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:32:50'),
(457, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:32:51'),
(458, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:32:52'),
(459, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:32:53'),
(460, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:32:55'),
(461, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:33:00'),
(462, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:33:08'),
(463, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:33:19'),
(464, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:33:21'),
(465, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:33:25'),
(466, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:33:33'),
(467, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:33:49'),
(468, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:34:14'),
(469, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:34:15'),
(470, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:34:16'),
(471, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:34:17'),
(472, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:34:18'),
(473, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:34:20'),
(474, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:34:24'),
(475, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:34:32'),
(476, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:34:34'),
(477, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:34:35'),
(478, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:34:35'),
(479, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:34:35'),
(480, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:34:35'),
(481, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:34:36'),
(482, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:34:36'),
(483, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:34:36'),
(484, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:34:36'),
(485, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:34:36'),
(486, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:34:37'),
(487, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:34:38'),
(488, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:34:40'),
(489, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:34:44'),
(490, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:34:52'),
(491, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:34:58'),
(492, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:35:00'),
(493, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:35:04'),
(494, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:35:07'),
(495, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:35:08'),
(496, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:35:09'),
(497, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:35:10'),
(498, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:35:12'),
(499, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:35:16'),
(500, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:35:24'),
(501, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:35:40'),
(502, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:35:42'),
(503, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:35:43'),
(504, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:35:43'),
(505, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:35:43'),
(506, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:35:43'),
(507, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:35:43'),
(508, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:35:43'),
(509, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:35:44'),
(510, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:35:44'),
(511, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:35:44'),
(512, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:35:44'),
(513, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:35:44'),
(514, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:35:44'),
(515, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:35:44'),
(516, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:35:44'),
(517, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:35:45'),
(518, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:35:46'),
(519, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:35:48'),
(520, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:35:52'),
(521, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:36:01'),
(522, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:36:09'),
(523, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:36:11'),
(524, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:36:15'),
(525, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:36:23'),
(526, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:36:31'),
(527, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:36:33'),
(528, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:36:35'),
(529, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:36:39'),
(530, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:36:47'),
(531, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:36:48'),
(532, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:36:49'),
(533, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:36:50'),
(534, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:36:51'),
(535, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:36:53'),
(536, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:36:57'),
(537, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:37:05'),
(538, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:37:05'),
(539, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:37:05'),
(540, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:37:06'),
(541, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:37:06'),
(542, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:37:06'),
(543, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:37:06'),
(544, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:37:06'),
(545, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:37:06'),
(546, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:37:06'),
(547, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:37:07'),
(548, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:37:07'),
(549, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:37:07'),
(550, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:37:07'),
(551, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:37:07'),
(552, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:37:07'),
(553, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:37:07'),
(554, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:37:07'),
(555, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:37:07'),
(556, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:37:21'),
(557, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:37:36'),
(558, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:37:37'),
(559, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:37:37'),
(560, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:37:38'),
(561, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:37:39'),
(562, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:37:41'),
(563, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:37:45'),
(564, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:37:53'),
(565, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:38:02'),
(566, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:38:02'),
(567, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:38:03'),
(568, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:38:03'),
(569, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:38:04'),
(570, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:38:05'),
(571, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:38:07'),
(572, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:38:11'),
(573, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:38:19'),
(574, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:38:27'),
(575, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:38:27'),
(576, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:38:28'),
(577, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:38:29'),
(578, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:38:31'),
(579, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:38:34'),
(580, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:38:35'),
(581, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:38:36'),
(582, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:38:37'),
(583, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:38:38'),
(584, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:38:38'),
(585, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:38:38'),
(586, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:38:38'),
(587, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:38:39'),
(588, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:38:39'),
(589, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:38:39'),
(590, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:38:39'),
(591, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:38:39'),
(592, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:38:39'),
(593, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:38:39'),
(594, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:38:39'),
(595, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:38:40'),
(596, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:38:40'),
(597, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:38:41'),
(598, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:38:42'),
(599, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:38:44'),
(600, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:38:48'),
(601, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:38:56'),
(602, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:39:12'),
(603, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:39:16'),
(604, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:39:18'),
(605, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:39:22'),
(606, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:39:23'),
(607, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:39:24'),
(608, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:39:25'),
(609, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:39:26'),
(610, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:39:28'),
(611, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:39:32'),
(612, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:39:40'),
(613, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:39:56'),
(614, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:40:00'),
(615, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:40:01'),
(616, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:40:01'),
(617, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:40:02'),
(618, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:40:04'),
(619, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:40:06'),
(620, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:40:10'),
(621, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:40:13'),
(622, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:40:15'),
(623, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:40:19'),
(624, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:40:27');
INSERT INTO `sensory_inputs` (`id`, `input_type`, `raw_data`, `processed_data`, `context_info`, `created_at`) VALUES
(625, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:40:41'),
(626, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:40:43'),
(627, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:40:47'),
(628, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:40:55'),
(629, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:41:11'),
(630, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:41:43'),
(631, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:42:18'),
(632, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:42:20'),
(633, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:42:24'),
(634, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:42:25'),
(635, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:42:27'),
(636, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:42:31'),
(637, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:42:36'),
(638, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:42:38'),
(639, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:42:42'),
(640, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:42:50'),
(641, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:43:06'),
(642, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:43:34'),
(643, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:43:36'),
(644, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:43:40'),
(645, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:43:45'),
(646, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:43:46'),
(647, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:43:46'),
(648, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:43:46'),
(649, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:43:46'),
(650, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:43:47'),
(651, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:43:47'),
(652, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:43:47'),
(653, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:43:47'),
(654, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:43:48'),
(655, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:43:49'),
(656, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:43:51'),
(657, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:43:55'),
(658, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:44:03'),
(659, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:44:15'),
(660, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:44:17'),
(661, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:44:21'),
(662, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:44:22'),
(663, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:44:23'),
(664, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:44:24'),
(665, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:44:25'),
(666, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:44:27'),
(667, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:44:31'),
(668, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:44:40'),
(669, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:44:56'),
(670, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:44:58'),
(671, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:45:02'),
(672, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:45:10'),
(673, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:45:27'),
(674, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:45:59'),
(675, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:46:01'),
(676, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:46:02'),
(677, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:46:03'),
(678, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:46:04'),
(679, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:46:06'),
(680, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:46:10'),
(681, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:46:18'),
(682, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:46:28'),
(683, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:46:30'),
(684, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:46:34'),
(685, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:46:38'),
(686, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:46:39'),
(687, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:46:39'),
(688, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:46:40'),
(689, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:46:41'),
(690, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:46:43'),
(691, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:46:46'),
(692, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:46:50'),
(693, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:46:53'),
(694, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:46:54'),
(695, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:46:55'),
(696, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:46:56'),
(697, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:46:58'),
(698, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:47:02'),
(699, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:47:10'),
(700, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:47:22'),
(701, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:47:22'),
(702, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:47:22'),
(703, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:47:22'),
(704, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:47:23'),
(705, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:47:23'),
(706, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:47:23'),
(707, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:47:23'),
(708, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:47:23'),
(709, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:47:23'),
(710, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:47:23'),
(711, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:47:24'),
(712, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:47:24'),
(713, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:47:25'),
(714, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:47:26'),
(715, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:47:28'),
(716, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:47:32'),
(717, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:47:40'),
(718, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:47:48'),
(719, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:47:48'),
(720, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:47:48'),
(721, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:47:48'),
(722, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:47:49'),
(723, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:47:49'),
(724, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:47:49'),
(725, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:47:49'),
(726, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:47:49'),
(727, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:47:49'),
(728, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:47:49'),
(729, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:47:49'),
(730, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:47:49'),
(731, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:47:50'),
(732, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:47:50'),
(733, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:47:50'),
(734, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:47:50'),
(735, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:47:50'),
(736, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:47:50'),
(737, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:49:20'),
(738, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:49:20'),
(739, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:49:20'),
(740, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:49:20'),
(741, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:49:20'),
(742, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:49:20'),
(743, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:49:20'),
(744, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:49:21'),
(745, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:49:21'),
(746, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:49:21'),
(747, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:49:21'),
(748, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:49:21'),
(749, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:49:21'),
(750, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:49:21'),
(751, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:49:22'),
(752, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:49:22'),
(753, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:49:22'),
(754, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:49:22'),
(755, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:49:22'),
(756, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:49:22'),
(757, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:49:22'),
(758, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:49:22'),
(759, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:49:22'),
(760, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:49:23'),
(761, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:49:23'),
(762, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:49:23'),
(763, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:49:23'),
(764, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:49:23'),
(765, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:49:23'),
(766, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:49:24'),
(767, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:49:24'),
(768, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:49:24'),
(769, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:49:24'),
(770, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:49:24'),
(771, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:49:24'),
(772, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:49:24'),
(773, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:49:24'),
(774, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:49:25'),
(775, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:49:25'),
(776, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:49:25'),
(777, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:49:25'),
(778, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:49:25'),
(779, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:49:25'),
(780, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:49:25'),
(781, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:49:25'),
(782, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:49:26'),
(783, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:49:26'),
(784, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:49:26'),
(785, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:49:26'),
(786, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:49:26'),
(787, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:49:26'),
(788, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:49:26'),
(789, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:49:26'),
(790, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:49:27'),
(791, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:49:27'),
(792, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:49:27'),
(793, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:49:27'),
(794, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:49:27'),
(795, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:49:27'),
(796, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:49:27'),
(797, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:49:27'),
(798, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:49:27'),
(799, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:49:28'),
(800, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:49:28'),
(801, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:49:28'),
(802, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:49:28'),
(803, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:49:28'),
(804, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:49:28'),
(805, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:49:29'),
(806, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:49:29'),
(807, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:49:29'),
(808, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:49:29'),
(809, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:49:29'),
(810, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:49:29'),
(811, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:49:29'),
(812, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:49:30'),
(813, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:49:30'),
(814, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:49:30'),
(815, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:49:30'),
(816, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:49:30'),
(817, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:49:30'),
(818, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:49:30'),
(819, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:49:30'),
(820, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:49:31'),
(821, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:49:31'),
(822, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:49:31'),
(823, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:49:31'),
(824, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:49:31'),
(825, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:49:31'),
(826, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:49:31'),
(827, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:49:32'),
(828, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:49:32'),
(829, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:49:32'),
(830, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:49:32'),
(831, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:49:32'),
(832, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:49:32'),
(833, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:49:32'),
(834, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:49:32'),
(835, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:49:32'),
(836, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:49:33'),
(837, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:49:33'),
(838, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:49:33'),
(839, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:49:33'),
(840, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:49:33'),
(841, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:49:33'),
(842, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:49:33'),
(843, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:49:34'),
(844, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:49:34'),
(845, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:49:34'),
(846, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:49:34'),
(847, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:49:34'),
(848, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:49:34'),
(849, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:49:34'),
(850, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:49:35'),
(851, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:49:35'),
(852, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:49:35'),
(853, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:49:35'),
(854, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:49:35'),
(855, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:49:35'),
(856, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:49:36'),
(857, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:49:36'),
(858, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:49:36'),
(859, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:49:36'),
(860, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:49:36'),
(861, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:49:36'),
(862, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:49:36'),
(863, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:49:37'),
(864, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:49:37'),
(865, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:49:37'),
(866, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:49:37'),
(867, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:49:37'),
(868, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:49:38'),
(869, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:49:38'),
(870, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:49:38'),
(871, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:49:38'),
(872, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:49:38'),
(873, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 05:49:38'),
(874, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:01'),
(875, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:01'),
(876, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:01'),
(877, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:02'),
(878, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:02'),
(879, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:02'),
(880, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:02'),
(881, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:02'),
(882, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:02'),
(883, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:02'),
(884, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:03'),
(885, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:03'),
(886, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:03'),
(887, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:03'),
(888, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:03'),
(889, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:03'),
(890, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:04'),
(891, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:04'),
(892, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:04'),
(893, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:04'),
(894, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:04'),
(895, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:04'),
(896, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:04'),
(897, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:04'),
(898, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:05'),
(899, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:05'),
(900, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:05'),
(901, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:05'),
(902, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:05'),
(903, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:05'),
(904, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:05'),
(905, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:06'),
(906, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:06'),
(907, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:06'),
(908, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:06'),
(909, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:06'),
(910, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:06'),
(911, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:06'),
(912, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:07'),
(913, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:07'),
(914, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:07'),
(915, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:07'),
(916, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:07'),
(917, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:07'),
(918, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:07'),
(919, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:07'),
(920, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:08'),
(921, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:08'),
(922, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:08'),
(923, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:08'),
(924, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:08'),
(925, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:08'),
(926, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:08'),
(927, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:09'),
(928, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:09'),
(929, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:09'),
(930, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:09'),
(931, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:09'),
(932, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:09'),
(933, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:09'),
(934, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:09'),
(935, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:10'),
(936, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:10'),
(937, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:10'),
(938, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:10'),
(939, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:10'),
(940, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:10'),
(941, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:10'),
(942, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:11'),
(943, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:11'),
(944, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:11'),
(945, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:11'),
(946, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:11'),
(947, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:11'),
(948, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:11'),
(949, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:11'),
(950, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:12'),
(951, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:12'),
(952, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:12'),
(953, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:12'),
(954, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:12'),
(955, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:12'),
(956, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:12'),
(957, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:13'),
(958, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:13'),
(959, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:13'),
(960, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:13'),
(961, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:13'),
(962, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:13'),
(963, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:13'),
(964, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:14'),
(965, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:14'),
(966, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:14'),
(967, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:14'),
(968, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:14'),
(969, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:14'),
(970, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:14'),
(971, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:14'),
(972, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:15'),
(973, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:15'),
(974, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:15'),
(975, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:15'),
(976, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:15'),
(977, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:15'),
(978, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:15'),
(979, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:16'),
(980, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:16'),
(981, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:16'),
(982, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:16'),
(983, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:16'),
(984, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:16'),
(985, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:16'),
(986, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:16'),
(987, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:16'),
(988, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:17'),
(989, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:17'),
(990, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:17'),
(991, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:17'),
(992, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:17'),
(993, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:17'),
(994, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:17'),
(995, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:18'),
(996, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:18'),
(997, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:18'),
(998, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:18'),
(999, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:18'),
(1000, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:18'),
(1001, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:18'),
(1002, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:19'),
(1003, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:19'),
(1004, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:19'),
(1005, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:19'),
(1006, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:19'),
(1007, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:19'),
(1008, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:19'),
(1009, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:20'),
(1010, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:20'),
(1011, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:20'),
(1012, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:20'),
(1013, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:20'),
(1014, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:20'),
(1015, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:20'),
(1016, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:20'),
(1017, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:20'),
(1018, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:21'),
(1019, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:21'),
(1020, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:21'),
(1021, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:21'),
(1022, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:21'),
(1023, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:21'),
(1024, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:22'),
(1025, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:22'),
(1026, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:22'),
(1027, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:22'),
(1028, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:22'),
(1029, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:22'),
(1030, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:22'),
(1031, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:23'),
(1032, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:23'),
(1033, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:23'),
(1034, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:23'),
(1035, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:23'),
(1036, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:23'),
(1037, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:23'),
(1038, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:24'),
(1039, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:24'),
(1040, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:24'),
(1041, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:24'),
(1042, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:24'),
(1043, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:24'),
(1044, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:24'),
(1045, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:25'),
(1046, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:25'),
(1047, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:25'),
(1048, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:25'),
(1049, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:25'),
(1050, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:25'),
(1051, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:25'),
(1052, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:25'),
(1053, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:26'),
(1054, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:26'),
(1055, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:26'),
(1056, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:26'),
(1057, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:26'),
(1058, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:26'),
(1059, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:26'),
(1060, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:13:27'),
(1061, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:02'),
(1062, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:03'),
(1063, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:03'),
(1064, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:03'),
(1065, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:03'),
(1066, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:03'),
(1067, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:03'),
(1068, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:04'),
(1069, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:04'),
(1070, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:04'),
(1071, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:04'),
(1072, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:04'),
(1073, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:04'),
(1074, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:04'),
(1075, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:05'),
(1076, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:05'),
(1077, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:05'),
(1078, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:05'),
(1079, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:05'),
(1080, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:05'),
(1081, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:05'),
(1082, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:05'),
(1083, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:06'),
(1084, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:06'),
(1085, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:06'),
(1086, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:06'),
(1087, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:06'),
(1088, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:06'),
(1089, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:11'),
(1090, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:11'),
(1091, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:12'),
(1092, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:12'),
(1093, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:12'),
(1094, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:12'),
(1095, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:12'),
(1096, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:12'),
(1097, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:12'),
(1098, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:12'),
(1099, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:13'),
(1100, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:13'),
(1101, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:13'),
(1102, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:13'),
(1103, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:13'),
(1104, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:13'),
(1105, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:14'),
(1106, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:14'),
(1107, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:14'),
(1108, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:14'),
(1109, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:14'),
(1110, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:14'),
(1111, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:14'),
(1112, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:15'),
(1113, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:15'),
(1114, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:15'),
(1115, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:15'),
(1116, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:15'),
(1117, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:15'),
(1118, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:15'),
(1119, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:15'),
(1120, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:16'),
(1121, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:16'),
(1122, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:16'),
(1123, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:16'),
(1124, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:16'),
(1125, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:16'),
(1126, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:16'),
(1127, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:17'),
(1128, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:17'),
(1129, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:17'),
(1130, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:17'),
(1131, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:17'),
(1132, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:17'),
(1133, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:18'),
(1134, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:18'),
(1135, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:18'),
(1136, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:18'),
(1137, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:18'),
(1138, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:18'),
(1139, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:19'),
(1140, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:19'),
(1141, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:19'),
(1142, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:19'),
(1143, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:19'),
(1144, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:19'),
(1145, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:20'),
(1146, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:20'),
(1147, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:20'),
(1148, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:20'),
(1149, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:20'),
(1150, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:20'),
(1151, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:20'),
(1152, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:20'),
(1153, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:21'),
(1154, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:21'),
(1155, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:21'),
(1156, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:21'),
(1157, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:21'),
(1158, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:21'),
(1159, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:22'),
(1160, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:22'),
(1161, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:22'),
(1162, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:22'),
(1163, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:22'),
(1164, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:22'),
(1165, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:22'),
(1166, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:23'),
(1167, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:23'),
(1168, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:23'),
(1169, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:23'),
(1170, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:23'),
(1171, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:23'),
(1172, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:23'),
(1173, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:24'),
(1174, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:24'),
(1175, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:24'),
(1176, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:24'),
(1177, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:24'),
(1178, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:24'),
(1179, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:24'),
(1180, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:25'),
(1181, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:25'),
(1182, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:25'),
(1183, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:25'),
(1184, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:25'),
(1185, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:25'),
(1186, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:26'),
(1187, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:26'),
(1188, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:26'),
(1189, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:26'),
(1190, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:26'),
(1191, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:26'),
(1192, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:26'),
(1193, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:27'),
(1194, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:27'),
(1195, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:27'),
(1196, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:27'),
(1197, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:27'),
(1198, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:27'),
(1199, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:27'),
(1200, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:27'),
(1201, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:28'),
(1202, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:28'),
(1203, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:28'),
(1204, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:28'),
(1205, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:28'),
(1206, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:28'),
(1207, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:29'),
(1208, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:29'),
(1209, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:29'),
(1210, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:29'),
(1211, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:29'),
(1212, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:29'),
(1213, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:29'),
(1214, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:30'),
(1215, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:30'),
(1216, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:30'),
(1217, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:30'),
(1218, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:31'),
(1219, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:31'),
(1220, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:31'),
(1221, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:31'),
(1222, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:31'),
(1223, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:31'),
(1224, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:31'),
(1225, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:31'),
(1226, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:32'),
(1227, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:32'),
(1228, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:32'),
(1229, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:32'),
(1230, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:32'),
(1231, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:32'),
(1232, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:32'),
(1233, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:33'),
(1234, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:33'),
(1235, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:33'),
(1236, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:33'),
(1237, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:33'),
(1238, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:33'),
(1239, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:33'),
(1240, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:33'),
(1241, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:34'),
(1242, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:34'),
(1243, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:34'),
(1244, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:34');
INSERT INTO `sensory_inputs` (`id`, `input_type`, `raw_data`, `processed_data`, `context_info`, `created_at`) VALUES
(1245, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:34'),
(1246, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:34'),
(1247, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:35'),
(1248, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:35'),
(1249, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:35'),
(1250, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:35'),
(1251, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:35'),
(1252, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:35'),
(1253, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:35'),
(1254, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:35'),
(1255, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:36'),
(1256, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:36'),
(1257, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:36'),
(1258, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:36'),
(1259, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:36'),
(1260, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:36'),
(1261, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:36'),
(1262, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:37'),
(1263, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:37'),
(1264, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:37'),
(1265, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:37'),
(1266, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:37'),
(1267, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:37'),
(1268, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:38'),
(1269, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:38'),
(1270, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:38'),
(1271, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:38'),
(1272, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:38'),
(1273, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:38'),
(1274, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:38'),
(1275, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:38'),
(1276, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:39'),
(1277, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:39'),
(1278, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:40'),
(1279, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:41'),
(1280, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:43'),
(1281, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:47'),
(1282, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:14:55'),
(1283, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:15:11'),
(1284, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:15:43'),
(1285, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:16:18'),
(1286, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:16:20'),
(1287, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:16:24'),
(1288, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:16:30'),
(1289, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:16:32'),
(1290, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:16:36'),
(1291, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:16:44'),
(1292, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:17:01'),
(1293, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:17:06'),
(1294, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:17:08'),
(1295, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:17:12'),
(1296, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:17:14'),
(1297, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:17:19'),
(1298, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:17:27'),
(1299, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:17:43'),
(1300, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:18:15'),
(1301, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:19:19'),
(1302, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:19:38'),
(1303, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:19:40'),
(1304, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:19:44'),
(1305, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:19:52'),
(1306, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:20:08'),
(1307, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:20:22'),
(1308, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:20:24'),
(1309, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:20:28'),
(1310, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:20:30'),
(1311, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:20:34'),
(1312, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:20:42'),
(1313, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:20:52'),
(1314, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:20:53'),
(1315, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:20:54'),
(1316, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:20:54'),
(1317, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:20:54'),
(1318, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:20:54'),
(1319, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:20:54'),
(1320, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:20:54'),
(1321, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:20:54'),
(1322, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:20:54'),
(1323, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:20:54'),
(1324, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:20:55'),
(1325, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:20:55'),
(1326, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:20:55'),
(1327, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:20:55'),
(1328, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:20:55'),
(1329, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:20:55'),
(1330, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:20:55'),
(1331, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:20:56'),
(1332, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:20:57'),
(1333, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:20:59'),
(1334, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:21:03'),
(1335, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:21:03'),
(1336, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:21:04'),
(1337, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:21:04'),
(1338, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:21:04'),
(1339, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:21:04'),
(1340, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:21:04'),
(1341, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:21:04'),
(1342, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:21:04'),
(1343, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:21:04'),
(1344, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:21:05'),
(1345, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:21:05'),
(1346, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:21:05'),
(1347, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:21:05'),
(1348, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:21:05'),
(1349, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:21:05'),
(1350, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 06:21:05'),
(1351, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:29'),
(1352, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:30'),
(1353, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:30'),
(1354, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:31'),
(1355, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:31'),
(1356, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:31'),
(1357, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:31'),
(1358, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:31'),
(1359, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:32'),
(1360, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:32'),
(1361, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:32'),
(1362, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:32'),
(1363, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:32'),
(1364, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:33'),
(1365, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:33'),
(1366, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:33'),
(1367, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:33'),
(1368, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:33'),
(1369, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:34'),
(1370, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:34'),
(1371, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:34'),
(1372, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:34'),
(1373, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:34'),
(1374, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:34'),
(1375, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:34'),
(1376, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:34'),
(1377, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:35'),
(1378, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:35'),
(1379, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:35'),
(1380, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:35'),
(1381, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:35'),
(1382, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:36'),
(1383, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:36'),
(1384, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:36'),
(1385, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:36'),
(1386, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:36'),
(1387, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:36'),
(1388, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:36'),
(1389, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:37'),
(1390, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:37'),
(1391, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:37'),
(1392, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:37'),
(1393, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:37'),
(1394, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:37'),
(1395, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:37'),
(1396, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:38'),
(1397, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:38'),
(1398, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:38'),
(1399, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:38'),
(1400, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:38'),
(1401, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:38'),
(1402, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:38'),
(1403, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:38'),
(1404, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:38'),
(1405, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:39'),
(1406, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:39'),
(1407, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:39'),
(1408, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:39'),
(1409, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:39'),
(1410, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:39'),
(1411, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:39'),
(1412, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:40'),
(1413, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:40'),
(1414, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:40'),
(1415, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:40'),
(1416, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:40'),
(1417, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:40'),
(1418, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:40'),
(1419, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:41'),
(1420, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:41'),
(1421, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:41'),
(1422, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:41'),
(1423, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:41'),
(1424, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:41'),
(1425, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:41'),
(1426, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:42'),
(1427, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:42'),
(1428, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:43'),
(1429, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:43'),
(1430, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:43'),
(1431, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:43'),
(1432, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:44'),
(1433, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:44'),
(1434, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:44'),
(1435, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:44'),
(1436, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:44'),
(1437, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:44'),
(1438, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:44'),
(1439, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:45'),
(1440, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:45'),
(1441, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:45'),
(1442, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:45'),
(1443, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:45'),
(1444, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:45'),
(1445, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:45'),
(1446, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:46'),
(1447, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:46'),
(1448, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:46'),
(1449, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:46'),
(1450, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:46'),
(1451, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:46'),
(1452, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:46'),
(1453, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:47'),
(1454, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:47'),
(1455, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:47'),
(1456, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:47'),
(1457, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:47'),
(1458, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:48'),
(1459, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:48'),
(1460, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:48'),
(1461, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:48'),
(1462, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:48'),
(1463, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:48'),
(1464, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:49'),
(1465, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:49'),
(1466, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:49'),
(1467, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:49'),
(1468, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:49'),
(1469, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:49'),
(1470, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:50'),
(1471, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:50'),
(1472, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:50'),
(1473, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:50'),
(1474, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:50'),
(1475, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:50'),
(1476, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:50'),
(1477, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:50'),
(1478, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:51'),
(1479, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:51'),
(1480, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:51'),
(1481, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:51'),
(1482, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:51'),
(1483, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:51'),
(1484, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:52'),
(1485, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:52'),
(1486, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:52'),
(1487, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:52'),
(1488, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:52'),
(1489, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:52'),
(1490, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:52'),
(1491, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:53'),
(1492, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:53'),
(1493, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:53'),
(1494, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:53'),
(1495, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:53'),
(1496, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:53'),
(1497, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:53'),
(1498, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:53'),
(1499, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:53'),
(1500, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:54'),
(1501, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:54'),
(1502, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:54'),
(1503, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:54'),
(1504, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:54'),
(1505, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:54'),
(1506, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:54'),
(1507, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:55'),
(1508, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:55'),
(1509, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:55'),
(1510, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:55'),
(1511, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:55'),
(1512, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:55'),
(1513, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:55'),
(1514, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:56'),
(1515, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:56'),
(1516, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:56'),
(1517, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:56'),
(1518, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:56'),
(1519, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:56'),
(1520, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:56'),
(1521, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:56'),
(1522, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:57'),
(1523, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:57'),
(1524, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:57'),
(1525, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:57'),
(1526, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:57'),
(1527, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:57'),
(1528, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:57'),
(1529, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:58'),
(1530, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:48:58'),
(1531, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:11'),
(1532, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:12'),
(1533, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:12'),
(1534, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:12'),
(1535, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:12'),
(1536, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:12'),
(1537, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:12'),
(1538, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:12'),
(1539, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:13'),
(1540, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:13'),
(1541, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:13'),
(1542, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:13'),
(1543, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:14'),
(1544, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:14'),
(1545, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:14'),
(1546, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:14'),
(1547, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:14'),
(1548, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:14'),
(1549, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:15'),
(1550, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:15'),
(1551, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:15'),
(1552, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:15'),
(1553, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:15'),
(1554, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:15'),
(1555, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:16'),
(1556, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:16'),
(1557, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:16'),
(1558, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:16'),
(1559, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:16'),
(1560, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:16'),
(1561, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:16'),
(1562, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:17'),
(1563, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:17'),
(1564, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:17'),
(1565, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:17'),
(1566, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:17'),
(1567, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:17'),
(1568, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:17'),
(1569, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:18'),
(1570, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:18'),
(1571, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:18'),
(1572, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:18'),
(1573, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:18'),
(1574, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:18'),
(1575, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:18'),
(1576, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:19'),
(1577, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:19'),
(1578, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:19'),
(1579, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:19'),
(1580, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:19'),
(1581, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:19'),
(1582, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:19'),
(1583, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:19'),
(1584, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:20'),
(1585, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:20'),
(1586, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:20'),
(1587, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:20'),
(1588, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:20'),
(1589, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:20'),
(1590, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:20'),
(1591, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:21'),
(1592, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:21'),
(1593, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:21'),
(1594, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:21'),
(1595, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:21'),
(1596, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:21'),
(1597, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:22'),
(1598, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:22'),
(1599, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:22'),
(1600, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:22'),
(1601, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:22'),
(1602, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:22'),
(1603, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:22'),
(1604, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:23'),
(1605, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:23'),
(1606, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:23'),
(1607, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:23'),
(1608, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:23'),
(1609, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:23'),
(1610, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:23'),
(1611, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:23'),
(1612, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:24'),
(1613, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:24'),
(1614, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:24'),
(1615, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:24'),
(1616, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:24'),
(1617, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:24'),
(1618, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:25'),
(1619, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:25'),
(1620, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:25'),
(1621, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:25'),
(1622, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:25'),
(1623, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:25'),
(1624, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:25'),
(1625, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:26'),
(1626, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:26'),
(1627, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:26'),
(1628, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:26'),
(1629, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:26'),
(1630, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:26'),
(1631, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:26'),
(1632, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:26'),
(1633, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:26'),
(1634, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:27'),
(1635, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:27'),
(1636, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:27'),
(1637, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:27'),
(1638, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:27'),
(1639, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:27'),
(1640, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:27'),
(1641, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:28'),
(1642, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:28'),
(1643, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:28'),
(1644, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:28'),
(1645, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:28'),
(1646, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:28'),
(1647, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:28'),
(1648, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:29'),
(1649, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:29'),
(1650, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:29'),
(1651, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:29'),
(1652, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:29'),
(1653, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:29'),
(1654, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:29'),
(1655, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:29'),
(1656, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:30'),
(1657, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:30'),
(1658, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:30'),
(1659, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:30'),
(1660, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:30'),
(1661, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:30'),
(1662, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:30'),
(1663, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:30'),
(1664, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:31'),
(1665, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:31'),
(1666, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:31'),
(1667, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:31'),
(1668, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:31'),
(1669, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:31'),
(1670, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:31'),
(1671, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:32'),
(1672, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:32'),
(1673, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:32'),
(1674, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:32'),
(1675, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:32'),
(1676, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:32'),
(1677, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:33'),
(1678, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:33'),
(1679, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:33'),
(1680, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:33'),
(1681, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:33'),
(1682, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:33'),
(1683, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:34'),
(1684, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:35'),
(1685, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:36'),
(1686, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:36'),
(1687, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:36'),
(1688, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:36'),
(1689, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:37'),
(1690, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:37'),
(1691, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:37'),
(1692, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:37'),
(1693, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:37'),
(1694, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:37'),
(1695, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:37'),
(1696, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:37'),
(1697, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:38'),
(1698, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:38'),
(1699, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:38'),
(1700, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:38'),
(1701, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:38'),
(1702, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:38'),
(1703, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:38'),
(1704, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:38'),
(1705, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:38'),
(1706, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:39'),
(1707, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:39'),
(1708, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:39'),
(1709, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:39'),
(1710, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:39'),
(1711, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:39'),
(1712, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:39'),
(1713, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:39'),
(1714, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:40'),
(1715, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:40'),
(1716, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:40'),
(1717, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:40'),
(1718, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:40'),
(1719, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:40'),
(1720, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:40'),
(1721, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:40'),
(1722, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:41'),
(1723, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:41'),
(1724, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:41'),
(1725, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:41'),
(1726, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:41'),
(1727, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:41'),
(1728, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:41'),
(1729, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:41'),
(1730, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:42'),
(1731, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:42'),
(1732, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:42'),
(1733, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:42'),
(1734, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:42'),
(1735, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:42'),
(1736, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:42'),
(1737, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:42'),
(1738, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:43'),
(1739, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:43'),
(1740, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:43'),
(1741, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:43'),
(1742, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:43'),
(1743, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:43'),
(1744, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:43'),
(1745, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:44'),
(1746, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:44'),
(1747, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:44'),
(1748, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:44'),
(1749, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:44'),
(1750, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:44'),
(1751, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:44'),
(1752, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:45'),
(1753, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:45'),
(1754, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:45'),
(1755, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:45'),
(1756, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:45'),
(1757, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:45'),
(1758, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:45'),
(1759, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:45'),
(1760, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:46'),
(1761, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:46'),
(1762, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:46'),
(1763, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:47'),
(1764, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:47'),
(1765, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:47'),
(1766, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:47'),
(1767, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:47'),
(1768, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:48'),
(1769, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:48'),
(1770, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:48'),
(1771, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:48'),
(1772, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:48'),
(1773, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:48'),
(1774, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:48'),
(1775, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:49'),
(1776, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:49'),
(1777, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:49'),
(1778, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:49'),
(1779, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:49'),
(1780, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:49'),
(1781, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:50'),
(1782, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:50'),
(1783, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:50'),
(1784, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:50'),
(1785, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:50'),
(1786, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:50'),
(1787, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:50'),
(1788, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:51'),
(1789, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:51'),
(1790, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:51'),
(1791, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:51'),
(1792, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:51'),
(1793, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:51'),
(1794, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:52'),
(1795, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:52'),
(1796, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:52'),
(1797, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:52'),
(1798, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:52'),
(1799, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:52'),
(1800, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:52'),
(1801, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:52'),
(1802, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:53'),
(1803, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:53'),
(1804, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:53'),
(1805, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:53'),
(1806, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:53'),
(1807, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:53'),
(1808, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:53'),
(1809, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:53'),
(1810, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:54'),
(1811, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:54'),
(1812, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:54'),
(1813, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:54'),
(1814, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:54'),
(1815, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:54'),
(1816, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:54'),
(1817, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:54'),
(1818, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:55'),
(1819, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:55'),
(1820, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:55'),
(1821, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:55'),
(1822, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:55'),
(1823, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:56'),
(1824, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:56'),
(1825, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:56'),
(1826, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:56'),
(1827, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:56'),
(1828, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:56'),
(1829, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:57'),
(1830, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:57'),
(1831, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:57'),
(1832, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:57'),
(1833, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:57'),
(1834, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:57'),
(1835, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:57'),
(1836, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:57'),
(1837, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:57'),
(1838, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:58'),
(1839, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:58'),
(1840, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:58'),
(1841, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:58'),
(1842, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:58'),
(1843, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:58'),
(1844, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:59'),
(1845, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:59'),
(1846, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:59'),
(1847, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:59'),
(1848, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:59'),
(1849, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:59'),
(1850, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:59'),
(1851, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:49:59'),
(1852, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:00'),
(1853, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:00'),
(1854, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:00'),
(1855, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:00'),
(1856, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:00'),
(1857, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:00'),
(1858, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:00'),
(1859, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:00');
INSERT INTO `sensory_inputs` (`id`, `input_type`, `raw_data`, `processed_data`, `context_info`, `created_at`) VALUES
(1860, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:01'),
(1861, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:01'),
(1862, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:01'),
(1863, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:01'),
(1864, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:01'),
(1865, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:01'),
(1866, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:01'),
(1867, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:01'),
(1868, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:02'),
(1869, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:02'),
(1870, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:02'),
(1871, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:02'),
(1872, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:02'),
(1873, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:02'),
(1874, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:03'),
(1875, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:03'),
(1876, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:03'),
(1877, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:03'),
(1878, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:03'),
(1879, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:03'),
(1880, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:03'),
(1881, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:03'),
(1882, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:04'),
(1883, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:04'),
(1884, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:04'),
(1885, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:04'),
(1886, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:04'),
(1887, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:04'),
(1888, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:04'),
(1889, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:04'),
(1890, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:05'),
(1891, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:05'),
(1892, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:06'),
(1893, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:07'),
(1894, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:09'),
(1895, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:13'),
(1896, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:14'),
(1897, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:14'),
(1898, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:14'),
(1899, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:15'),
(1900, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:15'),
(1901, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:15'),
(1902, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:15'),
(1903, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:15'),
(1904, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:15'),
(1905, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:15'),
(1906, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:15'),
(1907, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:16'),
(1908, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:16'),
(1909, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:16'),
(1910, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:16'),
(1911, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:16'),
(1912, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:16'),
(1913, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:17'),
(1914, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:17'),
(1915, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:17'),
(1916, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:17'),
(1917, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:17'),
(1918, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:17'),
(1919, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:17'),
(1920, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:18'),
(1921, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:18'),
(1922, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:18'),
(1923, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:18'),
(1924, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:18'),
(1925, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:18'),
(1926, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:19'),
(1927, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:19'),
(1928, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:19'),
(1929, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:19'),
(1930, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:19'),
(1931, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:19'),
(1932, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:19'),
(1933, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:19'),
(1934, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:20'),
(1935, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:20'),
(1936, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:20'),
(1937, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:20'),
(1938, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:20'),
(1939, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:20'),
(1940, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:20'),
(1941, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:20'),
(1942, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:21'),
(1943, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:21'),
(1944, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:21'),
(1945, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:21'),
(1946, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:21'),
(1947, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:21'),
(1948, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:22'),
(1949, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:22'),
(1950, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:22'),
(1951, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:22'),
(1952, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:22'),
(1953, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:22'),
(1954, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:22'),
(1955, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:23'),
(1956, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:40'),
(1957, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:41'),
(1958, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:41'),
(1959, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:42'),
(1960, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:42'),
(1961, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:42'),
(1962, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:42'),
(1963, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:43'),
(1964, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:43'),
(1965, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:43'),
(1966, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:43'),
(1967, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:43'),
(1968, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:43'),
(1969, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:44'),
(1970, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:44'),
(1971, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:44'),
(1972, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:44'),
(1973, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:44'),
(1974, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:44'),
(1975, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:44'),
(1976, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:45'),
(1977, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:45'),
(1978, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:45'),
(1979, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:45'),
(1980, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:45'),
(1981, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:45'),
(1982, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:46'),
(1983, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:46'),
(1984, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:46'),
(1985, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:46'),
(1986, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:46'),
(1987, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:46'),
(1988, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:46'),
(1989, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:47'),
(1990, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:47'),
(1991, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:47'),
(1992, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:47'),
(1993, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:47'),
(1994, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:47'),
(1995, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:47'),
(1996, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:47'),
(1997, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:48'),
(1998, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:48'),
(1999, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:48'),
(2000, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:48'),
(2001, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:48'),
(2002, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:48'),
(2003, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:48'),
(2004, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:49'),
(2005, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:49'),
(2006, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:49'),
(2007, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:49'),
(2008, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:49'),
(2009, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:50'),
(2010, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:50'),
(2011, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:50'),
(2012, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:50'),
(2013, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:50'),
(2014, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:50'),
(2015, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:50'),
(2016, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:51'),
(2017, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:51'),
(2018, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:51'),
(2019, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:51'),
(2020, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:51'),
(2021, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:51'),
(2022, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:52'),
(2023, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:52'),
(2024, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:52'),
(2025, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:52'),
(2026, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:52'),
(2027, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:52'),
(2028, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:52'),
(2029, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:53'),
(2030, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:53'),
(2031, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:53'),
(2032, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:53'),
(2033, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:53'),
(2034, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:53'),
(2035, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:54'),
(2036, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:54'),
(2037, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:54'),
(2038, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:54'),
(2039, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:54'),
(2040, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:54'),
(2041, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:54'),
(2042, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:55'),
(2043, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:55'),
(2044, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:55'),
(2045, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:55'),
(2046, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:55'),
(2047, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:55'),
(2048, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:56'),
(2049, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:56'),
(2050, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:56'),
(2051, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:56'),
(2052, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:56'),
(2053, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:56'),
(2054, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:57'),
(2055, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:57'),
(2056, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:57'),
(2057, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:57'),
(2058, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:57'),
(2059, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:57'),
(2060, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:57'),
(2061, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:57'),
(2062, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:58'),
(2063, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:58'),
(2064, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:58'),
(2065, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:58'),
(2066, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:58'),
(2067, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:58'),
(2068, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:59'),
(2069, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:59'),
(2070, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:59'),
(2071, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:59'),
(2072, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:59'),
(2073, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:59'),
(2074, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:50:59'),
(2075, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:51:00'),
(2076, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:51:00'),
(2077, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:51:00'),
(2078, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:51:00'),
(2079, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:51:00'),
(2080, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:51:00'),
(2081, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:51:00'),
(2082, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:51:01'),
(2083, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:51:01'),
(2084, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:51:01'),
(2085, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:51:01'),
(2086, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:51:01'),
(2087, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:51:01'),
(2088, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:51:02'),
(2089, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:51:02'),
(2090, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:51:02'),
(2091, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:51:02'),
(2092, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:51:02'),
(2093, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:51:02'),
(2094, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:51:03'),
(2095, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:51:03'),
(2096, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:51:03'),
(2097, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:51:03'),
(2098, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:51:03'),
(2099, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:51:03'),
(2100, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:51:04'),
(2101, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:51:04'),
(2102, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:51:04'),
(2103, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:51:04'),
(2104, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:51:04'),
(2105, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:51:04'),
(2106, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:51:04'),
(2107, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:51:04'),
(2108, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:51:05'),
(2109, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:51:05'),
(2110, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:51:05'),
(2111, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:51:05'),
(2112, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:51:05'),
(2113, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:51:05'),
(2114, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:51:05'),
(2115, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:51:05'),
(2116, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:51:06'),
(2117, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:51:06'),
(2118, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:51:06'),
(2119, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:51:06'),
(2120, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:51:06'),
(2121, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:51:06'),
(2122, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:51:06'),
(2123, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:51:07'),
(2124, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:51:07'),
(2125, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:51:07'),
(2126, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:51:07'),
(2127, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:51:07'),
(2128, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:51:07'),
(2129, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:51:07'),
(2130, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:51:08'),
(2131, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:51:08'),
(2132, '', NULL, '{\"audio\":0,\"motion\":[0,0,0]}', NULL, '2025-01-11 11:51:08');

-- --------------------------------------------------------

--
-- Table structure for table `sentence_structures`
--

CREATE TABLE `sentence_structures` (
  `id` int(11) NOT NULL,
  `pattern` text NOT NULL,
  `frequency` int(11) DEFAULT 1,
  `pattern_type` enum('statement','question','response') NOT NULL,
  `context_words` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`context_words`)),
  `success_rate` float DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `topics`
--

CREATE TABLE `topics` (
  `topic_id` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `description` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `topics`
--

INSERT INTO `topics` (`topic_id`, `name`, `description`, `created_at`) VALUES
(1, 'technology', 'Technology and innovation news', '2025-01-10 16:16:30'),
(2, 'science', 'Scientific discoveries and research', '2025-01-10 16:16:30'),
(3, 'economics', 'Economic trends and analysis', '2025-01-10 16:16:30'),
(4, 'business', 'Business news and corporate updates', '2025-01-10 16:16:30'),
(5, 'politics', 'Political news and government updates', '2025-01-10 16:16:30'),
(6, 'health', 'Health and medical news', '2025-01-10 16:16:30');

-- --------------------------------------------------------

--
-- Table structure for table `training_patterns`
--

CREATE TABLE `training_patterns` (
  `pattern_id` int(11) NOT NULL,
  `pattern_type` enum('sentence','phrase','transition') NOT NULL,
  `pattern_text` text NOT NULL,
  `usage_count` int(11) DEFAULT 1,
  `success_rate` float DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `last_used` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `training_workers`
--

CREATE TABLE `training_workers` (
  `worker_id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `status` enum('active','paused','completed') DEFAULT 'active',
  `progress` float DEFAULT 0,
  `started_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `last_updated_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `training_workers`
--

INSERT INTO `training_workers` (`worker_id`, `user_id`, `status`, `progress`, `started_at`, `last_updated_at`) VALUES
(1, 6, 'active', 0, '2025-01-12 01:26:29', '2025-01-12 06:29:46');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `user_id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `exp_points` int(11) DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `last_active` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `feedback_count` int(11) DEFAULT 0,
  `feedback_accuracy` float DEFAULT 1,
  `email` varchar(190) NOT NULL,
  `account_status` enum('active','suspended','inactive') DEFAULT 'active',
  `difficulty_level` enum('basic','intermediate','advanced') DEFAULT 'basic',
  `total_contributions` int(11) DEFAULT 0,
  `profile_picture` varchar(255) DEFAULT NULL,
  `password_hash` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`user_id`, `username`, `exp_points`, `created_at`, `last_active`, `feedback_count`, `feedback_accuracy`, `email`, `account_status`, `difficulty_level`, `total_contributions`, `profile_picture`, `password_hash`) VALUES
(1, 'TestUser', 195, '2025-01-10 16:17:01', '2025-01-11 23:20:17', 0, 1, '', 'active', 'basic', 0, NULL, '0'),
(2, 'Vikerus', 0, '2025-01-11 05:40:42', '2025-01-11 05:40:42', 0, 1, '', 'active', 'basic', 0, NULL, '0'),
(3, 'Vikerus1', 0, '2025-01-12 01:02:41', '2025-01-12 01:02:41', 0, 1, 'Vikerus1@gmail.com', 'active', 'basic', 0, NULL, '0'),
(4, 'Vikerus11', 0, '2025-01-12 01:03:55', '2025-01-12 01:03:55', 0, 1, 'vikerus11@gmail.com', 'active', 'basic', 0, NULL, '0'),
(5, 'Vikerus111', 0, '2025-01-12 01:07:47', '2025-01-12 01:07:47', 0, 1, 'jandersonjustis@gmail.com', 'active', 'basic', 0, NULL, '0'),
(6, 'Vikerus1111', 3700, '2025-01-12 01:13:49', '2025-01-13 07:34:48', 0, 1, 'iopkl@gmail.com', 'active', 'basic', 0, NULL, '$2y$10$JFT3QSNOPiPd/UD224DD4eEwo8zTTRfk6csg.ohQOXyOpt0.P7hy.');

-- --------------------------------------------------------

--
-- Table structure for table `user_contributions`
--

CREATE TABLE `user_contributions` (
  `contribution_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `article_id` int(11) DEFAULT NULL,
  `contribution_type` enum('article_submission','article_edit','comment','feedback','ai_training') NOT NULL,
  `xp_earned` int(11) DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `user_feedback`
--

CREATE TABLE `user_feedback` (
  `id` int(11) NOT NULL,
  `article_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `feedback_type` enum('accuracy','grammar','style','content') DEFAULT NULL,
  `feedback_text` text DEFAULT NULL,
  `sentiment_score` float DEFAULT NULL,
  `exp_awarded` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `word`
--

CREATE TABLE `word` (
  `id` int(11) NOT NULL,
  `word` varchar(255) NOT NULL,
  `related_words` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`related_words`)),
  `context_data` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`context_data`)),
  `frequency` int(11) DEFAULT 1,
  `part_of_speech` varchar(50) DEFAULT NULL,
  `is_connector` tinyint(1) DEFAULT 0,
  `last_used` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `word_relationships`
--

CREATE TABLE `word_relationships` (
  `word_id` int(11) NOT NULL,
  `word` varchar(100) NOT NULL,
  `related_words` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`related_words`)),
  `context_patterns` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`context_patterns`)),
  `occurrence_count` int(11) DEFAULT 1,
  `last_used` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `ai_responses`
--
ALTER TABLE `ai_responses`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `articles`
--
ALTER TABLE `articles`
  ADD PRIMARY KEY (`article_id`),
  ADD KEY `idx_articles_status` (`status`),
  ADD KEY `idx_articles_created` (`created_at`),
  ADD KEY `idx_article_conf` (`confidence_score`),
  ADD KEY `fk_article_user` (`user_id`),
  ADD KEY `idx_article_type` (`article_type`,`source_type`);

--
-- Indexes for table `article_edits`
--
ALTER TABLE `article_edits`
  ADD PRIMARY KEY (`edit_id`),
  ADD KEY `article_id` (`article_id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `reviewer_id` (`reviewer_id`),
  ADD KEY `idx_article_edits_status` (`status`),
  ADD KEY `idx_article_edits_created` (`created_at`);

--
-- Indexes for table `article_feedback`
--
ALTER TABLE `article_feedback`
  ADD PRIMARY KEY (`feedback_id`),
  ADD KEY `article_id` (`article_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `article_interactions`
--
ALTER TABLE `article_interactions`
  ADD PRIMARY KEY (`interaction_id`),
  ADD KEY `idx_article_interactions_article` (`article_id`),
  ADD KEY `idx_article_interactions_user` (`user_id`);

--
-- Indexes for table `article_tags`
--
ALTER TABLE `article_tags`
  ADD PRIMARY KEY (`tag_id`),
  ADD UNIQUE KEY `unique_article_tag` (`article_id`,`tag_name`),
  ADD KEY `idx_article_tags_tag` (`tag_name`);

--
-- Indexes for table `article_topics`
--
ALTER TABLE `article_topics`
  ADD PRIMARY KEY (`article_id`,`topic_id`),
  ADD KEY `topic_id` (`topic_id`);

--
-- Indexes for table `article_variations`
--
ALTER TABLE `article_variations`
  ADD PRIMARY KEY (`variation_id`),
  ADD KEY `parent_article_id` (`parent_article_id`);

--
-- Indexes for table `chat_responses`
--
ALTER TABLE `chat_responses`
  ADD PRIMARY KEY (`response_id`),
  ADD KEY `sensory_context_id` (`sensory_context_id`);

--
-- Indexes for table `comments`
--
ALTER TABLE `comments`
  ADD PRIMARY KEY (`comment_id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `idx_article_comments` (`article_id`);

--
-- Indexes for table `contextual_states`
--
ALTER TABLE `contextual_states`
  ADD PRIMARY KEY (`state_id`),
  ADD KEY `idx_context_timestamp` (`timestamp`);

--
-- Indexes for table `corrections`
--
ALTER TABLE `corrections`
  ADD PRIMARY KEY (`correction_id`),
  ADD KEY `article_id` (`article_id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `idx_corrections_status` (`status`);

--
-- Indexes for table `feedback`
--
ALTER TABLE `feedback`
  ADD PRIMARY KEY (`feedback_id`),
  ADD KEY `article_id` (`article_id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `idx_feedback_type` (`feedback_type`);

--
-- Indexes for table `learning_patterns`
--
ALTER TABLE `learning_patterns`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `multiplayer_states`
--
ALTER TABLE `multiplayer_states`
  ADD PRIMARY KEY (`state_id`),
  ADD KEY `idx_multiplayer_room` (`room_id`);

--
-- Indexes for table `sensory_data`
--
ALTER TABLE `sensory_data`
  ADD PRIMARY KEY (`data_id`),
  ADD KEY `idx_sensory_timestamp` (`timestamp`);

--
-- Indexes for table `sensory_influences`
--
ALTER TABLE `sensory_influences`
  ADD PRIMARY KEY (`influence_id`),
  ADD KEY `sensory_data_id` (`sensory_data_id`);

--
-- Indexes for table `sensory_inputs`
--
ALTER TABLE `sensory_inputs`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `sentence_structures`
--
ALTER TABLE `sentence_structures`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_pattern_success` (`success_rate`);

--
-- Indexes for table `topics`
--
ALTER TABLE `topics`
  ADD PRIMARY KEY (`topic_id`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Indexes for table `training_patterns`
--
ALTER TABLE `training_patterns`
  ADD PRIMARY KEY (`pattern_id`),
  ADD KEY `idx_training_patterns_type` (`pattern_type`);

--
-- Indexes for table `training_workers`
--
ALTER TABLE `training_workers`
  ADD PRIMARY KEY (`worker_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `username` (`username`);

--
-- Indexes for table `user_contributions`
--
ALTER TABLE `user_contributions`
  ADD PRIMARY KEY (`contribution_id`),
  ADD KEY `article_id` (`article_id`),
  ADD KEY `idx_user_contributions_user` (`user_id`),
  ADD KEY `idx_user_contributions_type` (`contribution_type`);

--
-- Indexes for table `user_feedback`
--
ALTER TABLE `user_feedback`
  ADD PRIMARY KEY (`id`),
  ADD KEY `article_id` (`article_id`);

--
-- Indexes for table `word`
--
ALTER TABLE `word`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_word_freq` (`frequency`);

--
-- Indexes for table `word_relationships`
--
ALTER TABLE `word_relationships`
  ADD PRIMARY KEY (`word_id`),
  ADD UNIQUE KEY `word_idx` (`word`),
  ADD KEY `idx_word_relationships_count` (`occurrence_count`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `ai_responses`
--
ALTER TABLE `ai_responses`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `articles`
--
ALTER TABLE `articles`
  MODIFY `article_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=115;

--
-- AUTO_INCREMENT for table `article_edits`
--
ALTER TABLE `article_edits`
  MODIFY `edit_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `article_feedback`
--
ALTER TABLE `article_feedback`
  MODIFY `feedback_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT for table `article_interactions`
--
ALTER TABLE `article_interactions`
  MODIFY `interaction_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `article_tags`
--
ALTER TABLE `article_tags`
  MODIFY `tag_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `article_variations`
--
ALTER TABLE `article_variations`
  MODIFY `variation_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `chat_responses`
--
ALTER TABLE `chat_responses`
  MODIFY `response_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `comments`
--
ALTER TABLE `comments`
  MODIFY `comment_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `contextual_states`
--
ALTER TABLE `contextual_states`
  MODIFY `state_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `corrections`
--
ALTER TABLE `corrections`
  MODIFY `correction_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `feedback`
--
ALTER TABLE `feedback`
  MODIFY `feedback_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `learning_patterns`
--
ALTER TABLE `learning_patterns`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `multiplayer_states`
--
ALTER TABLE `multiplayer_states`
  MODIFY `state_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `sensory_data`
--
ALTER TABLE `sensory_data`
  MODIFY `data_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `sensory_influences`
--
ALTER TABLE `sensory_influences`
  MODIFY `influence_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `sensory_inputs`
--
ALTER TABLE `sensory_inputs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2133;

--
-- AUTO_INCREMENT for table `sentence_structures`
--
ALTER TABLE `sentence_structures`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `topics`
--
ALTER TABLE `topics`
  MODIFY `topic_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `training_patterns`
--
ALTER TABLE `training_patterns`
  MODIFY `pattern_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `training_workers`
--
ALTER TABLE `training_workers`
  MODIFY `worker_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `user_contributions`
--
ALTER TABLE `user_contributions`
  MODIFY `contribution_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `user_feedback`
--
ALTER TABLE `user_feedback`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `word`
--
ALTER TABLE `word`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `word_relationships`
--
ALTER TABLE `word_relationships`
  MODIFY `word_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `articles`
--
ALTER TABLE `articles`
  ADD CONSTRAINT `fk_article_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`);

--
-- Constraints for table `article_edits`
--
ALTER TABLE `article_edits`
  ADD CONSTRAINT `article_edits_ibfk_1` FOREIGN KEY (`article_id`) REFERENCES `articles` (`article_id`),
  ADD CONSTRAINT `article_edits_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`),
  ADD CONSTRAINT `article_edits_ibfk_3` FOREIGN KEY (`reviewer_id`) REFERENCES `users` (`user_id`);

--
-- Constraints for table `article_feedback`
--
ALTER TABLE `article_feedback`
  ADD CONSTRAINT `article_feedback_ibfk_1` FOREIGN KEY (`article_id`) REFERENCES `articles` (`article_id`),
  ADD CONSTRAINT `article_feedback_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`);

--
-- Constraints for table `article_interactions`
--
ALTER TABLE `article_interactions`
  ADD CONSTRAINT `article_interactions_ibfk_1` FOREIGN KEY (`article_id`) REFERENCES `articles` (`article_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `article_interactions_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE SET NULL;

--
-- Constraints for table `article_tags`
--
ALTER TABLE `article_tags`
  ADD CONSTRAINT `article_tags_ibfk_1` FOREIGN KEY (`article_id`) REFERENCES `articles` (`article_id`) ON DELETE CASCADE;

--
-- Constraints for table `article_topics`
--
ALTER TABLE `article_topics`
  ADD CONSTRAINT `article_topics_ibfk_1` FOREIGN KEY (`article_id`) REFERENCES `articles` (`article_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `article_topics_ibfk_2` FOREIGN KEY (`topic_id`) REFERENCES `topics` (`topic_id`) ON DELETE CASCADE;

--
-- Constraints for table `article_variations`
--
ALTER TABLE `article_variations`
  ADD CONSTRAINT `article_variations_ibfk_1` FOREIGN KEY (`parent_article_id`) REFERENCES `articles` (`article_id`);

--
-- Constraints for table `chat_responses`
--
ALTER TABLE `chat_responses`
  ADD CONSTRAINT `chat_responses_ibfk_1` FOREIGN KEY (`sensory_context_id`) REFERENCES `contextual_states` (`state_id`);

--
-- Constraints for table `comments`
--
ALTER TABLE `comments`
  ADD CONSTRAINT `comments_ibfk_1` FOREIGN KEY (`article_id`) REFERENCES `articles` (`article_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `comments_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE SET NULL;

--
-- Constraints for table `corrections`
--
ALTER TABLE `corrections`
  ADD CONSTRAINT `corrections_ibfk_1` FOREIGN KEY (`article_id`) REFERENCES `articles` (`article_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `corrections_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE SET NULL;

--
-- Constraints for table `feedback`
--
ALTER TABLE `feedback`
  ADD CONSTRAINT `feedback_ibfk_1` FOREIGN KEY (`article_id`) REFERENCES `articles` (`article_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `feedback_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE SET NULL;

--
-- Constraints for table `sensory_influences`
--
ALTER TABLE `sensory_influences`
  ADD CONSTRAINT `sensory_influences_ibfk_1` FOREIGN KEY (`sensory_data_id`) REFERENCES `sensory_data` (`data_id`);

--
-- Constraints for table `training_workers`
--
ALTER TABLE `training_workers`
  ADD CONSTRAINT `training_workers_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`);

--
-- Constraints for table `user_contributions`
--
ALTER TABLE `user_contributions`
  ADD CONSTRAINT `user_contributions_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `user_contributions_ibfk_2` FOREIGN KEY (`article_id`) REFERENCES `articles` (`article_id`) ON DELETE SET NULL;

--
-- Constraints for table `user_feedback`
--
ALTER TABLE `user_feedback`
  ADD CONSTRAINT `user_feedback_ibfk_1` FOREIGN KEY (`article_id`) REFERENCES `articles` (`article_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
