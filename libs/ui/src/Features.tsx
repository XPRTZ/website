import {
  SparklesIcon,
  CpuChipIcon,
  LightBulbIcon,
} from "@heroicons/react/24/outline";
import Container from "./Container";

const features = [
  {
    name: "Focus",
    description:
      "Wij hebben een ding gemeen. Wij maken kick-ass .NET oplossingen voor onze klanten.",
    href: "#",
    icon: SparklesIcon,
  },
  {
    name: "Innovatie",
    description:
      "Wij bedenken vandaag innovatieve oplossingen voor de toekomst van onze klanten.",
    href: "#",
    icon: LightBulbIcon,
  },
  {
    name: "Techniek",
    description:
      "De beste hedendaagse tools & technieken behoren tot ons arsenaal.",
    href: "#",
    icon: CpuChipIcon,
  },
];

export default function Features() {
  return (
    <>
      <Container>
        <div className="grid grid-cols-1">
          <div className="grid grid-cols-1">
            <h2 className="text-3xl font-bold tracking-tight text-primary-900 sm:text-4xl text-center">
              Dé plek voor .NET experts!
            </h2>
            <p className="mx-auto mt-6 text-lg leading-8 text-gray-600">
              Lorem ipsum dolor sit amet consect adipisicing elit. Possimus
              magnam voluptatum cupiditate veritatis in accusamus quisquam.
            </p>
          </div>

          <div className="mx-auto mt-16 max-w-2xl sm:mt-20 lg:mt-24 lg:max-w-none">
            <dl className="grid max-w-xl grid-cols-1 gap-x-8 gap-y-16 lg:max-w-none lg:grid-cols-3">
              {features.map((feature) => (
                <div key={feature.name} className="flex flex-col">
                  <dt className="text-base font-semibold leading-7 text-primary-900">
                    <div className="mb-6 flex h-10 w-10 items-center justify-center rounded-lg bg-primary-600">
                      <feature.icon
                        className="h-6 w-6 text-white"
                        aria-hidden="true"
                      />
                    </div>
                    {feature.name}
                  </dt>
                  <dd className="mt-1 flex flex-auto flex-col text-base leading-7 text-gray-600">
                    <p className="flex-auto">{feature.description}</p>
                  </dd>
                </div>
              ))}
            </dl>
          </div>
        </div>
      </Container>
    </>
  );
}
