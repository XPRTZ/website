export type Author = {
    name: string;
    handle: string;
    imageURL: string;
    logoURL?: string;
};

export type Testimonial = {
    body: string;
    author: Author;
};

export type TestimonialArray = Testimonial[];         // Array of Testimonials
export type TestimonialGroup = TestimonialArray[];    // Array of arrays of Testimonials
export type NestedTestimonials = TestimonialGroup[];  // Array of Testimonial groups